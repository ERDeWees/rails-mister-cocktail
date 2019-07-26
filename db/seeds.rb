# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'

if Rails.env.development?
  Dose.destroy_all
  Ingredient.destroy_all
  Cocktail.destroy_all
end

puts "Deleted old data"

url = 'https://raw.githubusercontent.com/maltyeva/iba-cocktails/master/recipes.json'
opened = open(url).read
path = JSON.parse(opened)

path.each do |ct|
  drinks = Cocktail.create!(name: ct['name'], description: ct['category'], instructions: ct['preparation'])
  ct["ingredients"].each do |i|
    #Ingredients
    if i["ingredient"]
      ing = Ingredient.find_or_create_by(name: i["label"].nil? ? i["ingredient"] : i["label"])
    #Dose
      doses = Dose.create!(description: i["amount"].to_s + " " + i["unit"], cocktail: drinks, ingredient: ing)
      puts "Added #{doses.description} of #{ing.name} to #{drinks.name}"
    end
  end
end

puts "Loaded #{Cocktail.count} cocktails!"
