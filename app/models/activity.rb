class Activity < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :slots, dependent: :destroy
  has_one_attached :photo
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :setting, presence: true,
  validates :setting, inclusion: { in: %w(interieur exterieur) }
  validates :minimum_age, numericality: { only_integer: true }
  validates :duration, numericality: { only_integer: true }
end
