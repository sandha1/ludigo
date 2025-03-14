require 'csv'
require 'open-uri'

class LinkCloudinaryPhotosToActivities
  def call
    path = Rails.root.join('db', 'activities_photo_urls.csv')
    CSV.foreach(path, headers: :first_row) do |row|
      activity = Activity.find_by(name: row['name'])
      next unless activity.present?

      p row['url']
      file =  URI.parse(row['url']).open
      activity.photo.attach(io: file, filename: "#{activity.name.parameterize}.png", content_type: "image/png") unless file.nil?

    rescue OpenURI::HTTPError => e
      puts "Could not read image for #{row['url']}"
    end
  end
end
