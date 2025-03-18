class Weather < ApplicationRecord
  serialize :data, JSON
  
  def self.for_today
    find_by(date: Date.today)
  end
end
