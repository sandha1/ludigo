require "open-uri"

class GetWeatherJob < ApplicationJob
  queue_as :default

  def perform
    today = Date.today.strftime("%Y-%m-%d")
    end_date = (Date.today + 14).strftime("%Y-%m-%d")

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/paris/#{today}/#{end_date}?unitGroup=us&elements=datetimeEpoch%2Ctemp%2Cfeelslike%2Cconditions%2Cdescription%2Cicon&include=days&key=#{ENV["WEATHER_KEY"]}&contentType=json"

    begin
      response = JSON.parse(URI.parse(url).read)

      if response["days"].present?
        today = Date.today

        daily_weather = response["days"]
                          .select { |day| Time.at(day["datetimeEpoch"]).utc.to_date >= today }
                          .map do |day|
          {
            "datetime" => Time.at(day["datetimeEpoch"]).utc.to_date.to_s,
            "temp" => day["temp"],
            "feelslike" => day["feelslike"],
            "description" => day["description"].empty? ? "Pas de description disponible" : day["description"],
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
