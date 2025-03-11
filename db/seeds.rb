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
Activity.destroy_all

puts "Cleaned my database"

Elisa = User.create!(email: "elisa@gmail.com", password: "bonjour")
Frankie = User.create!(email: "frankie@gmail.com", password: "bonjour")

activity1 = Activity.new(name: "Scrapbooking", description: "Stinking bishop cauliflower cheese pepper jack. Red leicester goat cheese triangles roquefort pepper jack dolcelatte fromage cheeseburger. Pecorino chalk and cheese fondue bocconcini the big cheese swiss goat cheese triangles. Airedale dolcelatte who moved my cheese.", setting: "intérieur")
activity1.save!

activity2 = Activity.new(name: "Jardinage", description: "Stinking bishop cauliflower cheese pepper jack. Red leicester goat cheese triangles roquefort pepper jack dolcelatte fromage cheeseburger. Pecorino chalk and cheese fondue bocconcini the big cheese swiss goat cheese triangles. Airedale dolcelatte who moved my cheese.", setting: "extérieur")
activity2.save!

activity3 = Activity.new(name: "Cache cache", description: "Stinking bishop cauliflower cheese pepper jack. Red leicester goat cheese triangles roquefort pepper jack dolcelatte fromage cheeseburger. Pecorino chalk and cheese fondue bocconcini the big cheese swiss goat cheese triangles. Airedale dolcelatte who moved my cheese.", setting: "extérieur")
activity3.save!

activity4 = Activity.new(name: "Cuisine", description: "Stinking bishop cauliflower cheese pepper jack. Red leicester goat cheese triangles roquefort pepper jack dolcelatte fromage cheeseburger. Pecorino chalk and cheese fondue bocconcini the big cheese swiss goat cheese triangles. Airedale dolcelatte who moved my cheese.", setting: "intérieur")
activity4.save!

activity5 = Activity.new(name: "Peinture", description: "Stinking bishop cauliflower cheese pepper jack. Red leicester goat cheese triangles roquefort pepper jack dolcelatte fromage cheeseburger. Pecorino chalk and cheese fondue bocconcini the big cheese swiss goat cheese triangles. Airedale dolcelatte who moved my cheese.", setting: "intérieur")
activity5.save!

favorite1 = Favorite.new(activity: activity5, user: Elisa)
favorite1.save!

favorite1 = Favorite.new(activity: activity2, user: Elisa)
favorite1.save!

puts "Created #{Activity.count} activities and #{Favorite.count} favorites."

# elisa_slot1 = Slot.new(start_at: )
