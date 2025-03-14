# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.destroy_all
Slot.destroy_all

puts "Cleaned my database"

Elisa = User.create!(email: "elisa@gmail.com", password: "ludigo")
Frankie = User.create!(email: "frankie@gmail.com", password: "ludigo")

start_at_8h30 = DateTime.now.change({ hour: 8, min: 30 })
end_at_10 = DateTime.now.change({ hour: 10 })
slot1 = Slot.create!(start_at: start_at_8h30, end_at: end_at_10, user: Elisa)

start_at_10 = DateTime.now.change({ hour: 10 })
end_at_11h30 = DateTime.now.change({ hour: 11, min: 30 })
slot2 = Slot.create!(start_at: start_at_10, end_at: end_at_11h30, user: Elisa)

start_at_13h30 = DateTime.now.change({ hour: 13, min: 30 })
end_at_15 = DateTime.now.change({ hour: 15 })
slot3 = Slot.create!(start_at: start_at_13h30, end_at: end_at_15, user: Elisa)

start_at_15 = DateTime.now.change({ hour: 15 })
end_at_16h30 = DateTime.now.change({ hour: 16, min: 30 })
slot4 = Slot.create!(start_at: start_at_15, end_at: end_at_16h30, user: Elisa)


ScrapeWebAlain.new.call

favorite1 = Favorite.new(activity: Activity.first, user: Elisa)
favorite1.save!

favorite1 = Favorite.new(activity: Activity.second, user: Elisa)
favorite1.save!

puts "Created #{Activity.count} activities."

puts 'Chargement des images depuis Cloudinary'
LinkCloudinaryPhotosToActivities.new.call
puts 'Done!!!!'
