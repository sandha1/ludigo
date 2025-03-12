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

end
