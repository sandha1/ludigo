require 'csv'
require 'open-uri'

class LinkCloudinaryPhotosToActivities
  def call
    path = Rails.root.join('db', 'activities_photo_urls.csv')
    CSV.foreach(path, headers: :first_row) do |row|
      activity = Activity.find_by(name: row['name'])

      unless activity.nil?
        activity.photo.purge if activity.photo.attached?

        activity_file_name = activity.name.parameterize
        activity_name_filepath = "app/assets/images/illustrations/#{activity_file_name}.jpg"
        cloudinary_object = Cloudinary::Uploader.upload(activity_name_filepath)

        url = cloudinary_object['url']
        file = URI.parse(url).open
        # file = File.open(activity_name_file)
        # binding.pry

        # p url

        # file =  URI.parse(row['url']).open
        activity.photo.attach(io: file, filename: activity_file_name, content_type: "image/jpg") unless file.nil?
      end
    end
  end
end
