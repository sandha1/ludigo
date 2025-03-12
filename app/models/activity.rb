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
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :setting, presence: true
  validates :setting, inclusion: { in: %w(intérieur extérieur) }
  # validates :minimum_age, numericality: { only_integer: true }
  # validates :duration, numericality: { only_integer: true }

  after_save :set_photo, if: -> { saved_change_to_name? || !photo.attached? }

  private

  def set_photo
    client = OpenAI::Client.new(api_key: ENV['OPENAI_ACCESS_TOKEN'])

    response = client.images.generate(
      parameters: {
        prompt: "An image that corresponds to the activity based on #{name}",
        size: "256x256",
       }
    )

    url = response["data"][0]["url"]
    file =  URI.parse(url).open

    photo.purge if photo.attached?
    photo.attach(io: file, filename: "ai_generated_image.jpg", content_type: "image/png")

    return photo
  end

end
