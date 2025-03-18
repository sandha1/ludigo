require "open-uri"

class GetWeatherJob < ApplicationJob
  queue_as :default

  def perform
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/paris?unitGroup=us&elements=datetimeEpoch%2Ctemp%2Cfeelslike%2Cconditions%2Cdescription%2Cicon&include=days%2Ccurrent&key=#{ENV["WEATHER_KEY"]}&contentType=json"

    begin
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

        Weather.create!(date: Date.today, data: daily_weather)

      else
        daily_weather = []
      end

    rescue StandardError => erreur
      Rails.logger.error "Aucune donnée météo trouvée: #{erreur.message}"
    end
  end
end
