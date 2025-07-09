class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :activities, through: :favorites
  has_many :slots, dependent: :destroy

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
end
