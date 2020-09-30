require 'faraday'
require 'json'
require 'tty-prompt'
require 'byebug'
require_relative 'recipe_card'
require_relative 'recipehelper'


class Api
  include Faraday
  include RecipeHelper
  @@api_root = "https://api.spoonacular.com"
  @@api_key = "?apiKey=945916246cc3460dbfe56c71616e4d96"
  # @@api_search_by_type_for_fish= "https://api.spoonacular.com/recipes/complexSearch?apiKey=945916246cc3460dbfe56c71616e4d96&query=fish"
  def initialze
    read_recipes
  end
  def search_api_recipes
    content = JSON.parse(Faraday.get("#{@@api_root}/recipes/random#{@@api_key}").body)["recipes"]
    convert_api_data(content)
    
  end
 def convert_api_data(data)
  @results = {}
  @results[:name] = data[0]["title"] # returns string
  @results[:serves] = data[0]['servings']
  @results[:description] = data[0]['summary'].gsub(/<\/?[^>]+>/, '')
  @results[:ingredients] = data[0]["extendedIngredients"].map{|s|s["originalString"]}
  @results[:recipe] = data[0]["instructions"].gsub(/<\/?[^>]+>/, '').gsub("\n", '') # returns string
  @results[:time_to_cook] = data[0]["readyInMinutes"] # returns integer, turn to stirng if needed?
  @results[:url] = data[0]['sourceUrl']
  @results
 end

  def user_recipe(*)
    @results = RecipeCard.new(:name, :serves, :description, :time_to_cook, :recipe, :url)
  end

  def write_recipes
    @file = read_recipes
    @file << @results
    File.write(RECIPES_PATH, JSON.pretty_generate(@file))
  end

  def read_recipes
    file = File.read(RECIPES_PATH)
    file_hash = JSON.parse(file)
    file_hash
  end

  def select_recipe(num)
    read_recipes[num].map do |k,r| 
  puts "#{k}"
  puts ""
  puts "#{r}"
  byebug
end
  end
end

request = Api.new
request.read_recipes
p request.search_api_recipes

request.write_recipes
