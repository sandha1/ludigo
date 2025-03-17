require "open-uri"

class GetWeatherJob < ApplicationJob
  queue_as :default

  def perform
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/paris?unitGroup=us&elements=datetimeEpoch%2Ctemp%2Cfeelslike%2Cconditions%2Cdescription%2Cicon&include=days%2Ccurrent&key=#{ENV["WEATHER_KEY"]}&contentType=json"
    response = JSON.parse(URI.parse(url).read)

    if response["days"].present?
      daily_weather = response["days"].map do |day|
        {
        "datetime" => Time.at(day["datetimeEpoch"]).to_date.to_s,
        "temp" => day["temp"],
        "feelslike" => day["feelslike"],
        "description" => day["description"],
        "icon" => day["icon"]
        }
      end
    else
      daily_weather = []
    end
    Rails.cache.write("daily_weather", daily_weather, expires_in: 24.hours)
  end
end
