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

  AGE_RANGES = {
    "3-5" => (3..5),
    "6-10" => (6..10),
    "11-13" => (11..Float::INFINITY)
  }

  def self.search_with_filters(results, filters = {})
    results = search_by_name_and_description(filters[:query]) if filters[:query]
    results = results.where(setting: filters[:setting]) if filters[:setting].present?

    if filters[:minimum_age].present? && AGE_RANGES.key?(filters[:minimum_age])
      results = results.where(minimum_age: AGE_RANGES[filters[:minimum_age]])
    end
    results
  end

  def formatted_age
    minimum_age == 0 ? "3+" : minimum_age.to_s + "+"
  end
end
