require 'openai'
require 'open-uri'

class Activity < ApplicationRecord

  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
  against: [ :name, :description ],
  using: {
    tsearch: { prefix: true }
  }

  has_many :favorites, dependent: :destroy
  has_many :slots, dependent: :nullify
  has_one_attached :photo
  validates :name, presence: true, uniqueness: { case_sensitive: true }
  validates :description, presence: true
  validates :setting, presence: true
  # validates :minimum_age, numericality: { only_integer: true }
  # validates :duration, numericality: { only_integer: true }

  def Activity.search_with_filters(query, setting)
    results = search_by_setting(query)

    results = results.where(setting: setting) if setting.present?
    results
  end

  def formatted_duration
    duration.to_s.scan(/[\d-]+/).join(' ')
  end

  def formatted_age
    minimum_age == 0 ? "Tout âge" : minimum_age.to_s + " ans"
  end

  def image_for_setting
      if setting == "extérieur"
        "icons/sun.png"
      else
        "icons/lamp.png"
      end
  end


  def image_path
    filename = "#{name.downcase.gsub(' ', '-')}.jpg"
    if Rails.application.assets.find_asset("illustrations/#{filename}").present?
      "/assets/illustrations/#{filename}"
    else
      "/assets/board-game.png"
    end
  end


  # after_save :set_photo, if: -> { saved_change_to_name? || !photo.attached? }

  # private

  # def set_photo
  #   puts name
  #   client = OpenAI::Client.new(api_key: ENV['OPENAI_ACCESS_TOKEN'])
  #   file = nil
  #   begin
  #     response = client.images.generate(
  #       parameters: {
  #         prompt: "Generate a colorful, playful, and vibrant illustration based on the following children's camp activity #{name}. Each image should visually represent the essence of the #{name} in a fun, child-friendly way, without including people or anything strange. Keep the illustrations bright, inviting, and perfect for a children's camp atmosphere.",
  #         size: "256x256",
  #       }
  #     )

  #     url = response["data"][0]["url"]
  #     file =  URI.parse(url).open
  #   rescue Faraday::BadRequestError
  #     puts "bad request"
  #     nil
  #   rescue => error
  #     puts error.message
  #   end

  #   photo.purge if photo.attached?

  #   photo.attach(io: file, filename: "#{name.parameterize}.png", content_type: "image/png") unless file.nil?
  # end
end
