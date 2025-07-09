class Favorite < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  
  validates :activity_id, presence: true
  validates :user_id, presence: true
  validates :user, uniqueness: { scope: :activity }
end
