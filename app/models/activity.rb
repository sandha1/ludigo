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

  def self.search_with_filters(results, filters = {})
    results = search_by_name_and_description(filters[:query]) if filters[:query]

    results = results.where(setting: filters[:setting]) if filters[:setting].present?
    # results = results.where("minimum_age >= ?", filters[:minimum_age]) if filters[:minimum_age].present?
    results = results.where("? <= max_duration", filters[:max_duration]) if filters[:max_duration].present?

    # if filters[:minimum_age].present?
    #   selected_range = @age_ranges[filters[:minimum_age]]
    #   @activities = @activities.where(minimum_age: selected_range) if selected_range
    # end

    results
  end

  # def duration_time
  #   Activity.first.duration.split(' ').third.to_i
  # end

  def formatted_duration
    duration.to_s.scan(/[\d-]+/).join(' ')
  end

  def formatted_age
    minimum_age == 0 ? "Tout âge" : "> " + minimum_age.to_s + " ans"
  end

  def image_for_setting
      if setting == "extérieur"
        "icons/sun.png"
      else
        "icons/house.png"
      end
  end

end
