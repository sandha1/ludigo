require "open-uri"

class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
    # Old api meteo
    # location_url = "http://dataservice.accuweather.com/locations/v1/search?q=paris&apikey=#{ENV["APIKEY"]}"
    # location_key = JSON.parse(URI.parse(location_url).read)[0]["Key"]

    # daily_url = "http://dataservice.accuweather.com/forecasts/v1/daily/1day/623?apikey=#{ENV["APIKEY"]}"
    # @daily_weather = JSON.parse(URI.parse(daily_url).read)["DailyForecasts"][0]["Day"]

    # if @daily_weather["Icon"] < 10
      # @icon_url = "https://developer.accuweather.com/sites/default/files/0#{@daily_weather["Icon"]}-s.png"
    # else
      # @icon_url = "https://developer.accuweather.com/sites/default/files/#{@daily_weather["Icon"]}-s.png"
    # end

    # @daily_temperature = @daily_weather["Temperature"]

    # New api meteo
    # url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/paris?unitGroup=us&elements=temp%2Cfeelslike%2Cdescription%2Cicon&include=days&key=CYKUZT69SRDD4TWUXYDCSEMEY&contentType=json"
    # @daily_weather = JSON.parse(URI.parse(url).read)["days"].first

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
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/paris?unitGroup=us&elements=name%2Ctemp%2Cfeelslike%2Cdescription%2Cicon&include=fcst%2Cdays%2Ccurrent&key=CYKUZT69SRDD4TWUXYDCSEMEY&contentType=json"
    @current_weather = JSON.parse(URI.parse(url).read)["currentConditions"]

    temperature_f =  @current_weather["temp"]
    @temperature_c = (temperature_f - 32) * 5 / 9

    feel_temperature_f = @current_weather["feelslike"]
    @feel_temperature_c = (feel_temperature_f - 32) * 5 / 9
  end

  def daily_weather
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/paris?unitGroup=us&elements=name%2Ctemp%2Cfeelslike%2Cdescription%2Cicon&include=fcst%2Cdays%2Ccurrent&key=CYKUZT69SRDD4TWUXYDCSEMEY&contentType=json"
    @current_weather = JSON.parse(URI.parse(url).read)["currentConditions"]
    @daily_weather = JSON.parse(URI.parse(url).read)["days"]
  end
end
