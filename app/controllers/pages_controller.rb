require "open-uri"

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    activities = Activity.all
    @random_activity = activities.sample

    current_weather

    slots = Slot.all
    today = Date.today

    @today_slots = current_user.slots.where(start_at: today.beginning_of_day..today.end_of_day).order(:start_at)
  end

  def planning
    current_weather
    daily_weather

    selected_date = params.fetch(:start_date, DateTime.now).to_datetime.in_time_zone('Paris')
    @selected_month = I18n.l(selected_date, format: "%B %Y").capitalize

    @slots = current_user.slots.where(start_at: selected_date.beginning_of_day()..selected_date.end_of_day).order(:start_at)
    day_slots = [ selected_date.change({ hour: 8, min: 30 }), selected_date.change({ hour: 10 }), selected_date.change({ hour: 13, min: 30 }), selected_date.change({ hour: 15 })]

    if @slots.length < 4
      incomplete_dates = day_slots -  @slots.pluck(:start_at)

      incomplete_dates.each do |incomplete_date|
        Slot.create(start_at: incomplete_date, end_at: incomplete_date + 1.hour + 30.minutes, user: current_user)
      end
      @slots = current_user.slots.where(start_at: selected_date.beginning_of_day()..selected_date.end_of_day).order(:start_at)
    end

    @favorites = current_user.favorites
  end

  private

  def current_weather
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/paris?unitGroup=us&elements=name%2Ctemp%2Cfeelslike%2Cdescription%2Cicon&include=fcst%2Cdays%2Ccurrent&key=#{ENV["WEATHER_KEY"]}&contentType=json"
    response = JSON.parse(URI.parse(url).read)

    if response["currentConditions"].present?
      @current_weather = response["currentConditions"]
    end

    temperature_f =  @current_weather["temp"]
    @temperature_c = (temperature_f - 32) * 5 / 9

    feel_temperature_f = @current_weather["feelslike"]
    @feel_temperature_c = (feel_temperature_f - 32) * 5 / 9
  end

  def daily_weather
    record = Weather.for_today

    if record
      @daily_weather = record.data
    else
      # Weather.delete_all
      GetWeatherJob.perform_now
      @daily_weather = Weather.last.data
    end
  end
end
