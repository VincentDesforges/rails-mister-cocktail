# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

puts 'Cleaning database...'
Cocktail.destroy_all
Dose.destroy_all
Ingredient.destroy_all

puts 'Creating ingredients...'


data = JSON.parse(open('http://www.thecocktaildb.com/api/json/v1/1/list.php?i=list').read)

data["drinks"].each do |ingredient|
  Ingredient.create!(name: ingredient["strIngredient1"])
end

puts 'Getting cocktails and doses...'

cocktail_id_json = JSON.parse(open("http://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic").read)
# cocktail_database_json = JSON.parse(open("http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=13060").read)
# "http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=13060"
# "http://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic"

cocktail_ids = []

cocktail_id_json["drinks"].each do |cocktail|
  cocktail_ids << cocktail["idDrink"]
end

# p cocktail_ids

cocktail_ids.each do |cocktail_id|
  url= "http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{cocktail_id}"
  cocktail_json = JSON.parse(open(url).read)
  cocktail = Cocktail.new(name: cocktail_json["drinks"].first["strDrink"])
  cocktail.save

  15.times do |i|
    ingredient = Ingredient.find_by_name(cocktail_json["drinks"].first["strIngredient#{i}"])
    dose = Dose.new(description: cocktail_json["drinks"].first["strMeasure#{i}"])
    dose.ingredient = ingredient
    dose.cocktail = cocktail
    dose.save
  end

end


puts 'Finished!'
