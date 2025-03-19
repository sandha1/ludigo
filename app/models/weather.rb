class Weather < ApplicationRecord
  serialize :data, JSON

  def self.for_today
    where(date: Date.today).order(created_at: :desc).first
  end
end
