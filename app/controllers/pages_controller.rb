require "open-uri"

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    location_url = "http://dataservice.accuweather.com/locations/v1/search?q=paris&apikey=#{ENV["APIKEY"]}"
    location_key = JSON.parse(URI.parse(location_url).read)[0]["Key"]

    daily_url = "http://dataservice.accuweather.com/forecasts/v1/daily/1day/623?apikey=#{ENV["APIKEY"]}"
    @daily_weather = JSON.parse(URI.parse(daily_url).read)["DailyForecasts"][0]["Day"]

    if @daily_weather["Icon"] < 10
      @icon_url = "https://developer.accuweather.com/sites/default/files/0#{@daily_weather["Icon"]}-s.png"
    else
      @icon_url = "https://developer.accuweather.com/sites/default/files/#{@daily_weather["Icon"]}-s.png"
    end

    # @daily_temperature = @daily_weather["Temperature"]
  end

  def planning
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
end
