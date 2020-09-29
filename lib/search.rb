require 'faraday'
require 'json'
require 'tty-prompt'
require 'byebug'
require_relative 'recipe_card'
module RecipeHelper
  RECIPES_PATH = "../public/recipes.json"
  PROMPT = TTY::Prompt.new
end

class Api
  include Faraday
  include RecipeHelper
  @api_root = "https://api.spoonacular.com"
  @api_key = "?apiKey=945916246cc3460dbfe56c71616e4d96"
  # @@api_search_by_type_for_fish= "https://api.spoonacular.com/recipes/complexSearch?apiKey=945916246cc3460dbfe56c71616e4d96&query=fish"
  def initialze
    read_recipes
  end
  def search_complex_search(query)
    parsed_hash = JSON.parse(Faraday.get("https://api.spoonacular.com/recipes/complexSearch?apiKey=945916246cc3460dbfe56c71616e4d96&query=#{query}").body)
    content = parsed_hash["recipes"]
    @results = {}
    @results[:name] = content[0]["title"] # returns string
    @results[:serves] = content[0]['servings']
    @results[:description] = content[0]['summary'].gsub(/<\/?[^>]+>/, '')
    @results[:recipe] = content[0]["instructions"].gsub(/<\/?[^>]+>/, '').gsub("\n", '') # returns string
    @results[:time_to_cook] = content[0]["readyInMinutes"] # returns integer, turn to stirng if needed?
    @results[:url] = content[0]['sourceUrl']
    @results
  end

  def search_api_recipes
    parsed_hash = JSON.parse(Faraday.get("#{@api_root}/recipes/random#{@api_key}").body)
    content = parsed_hash["recipes"]
    @results ={}
      @results[:name] = content[0]["title"] # returns string
    @results[:serves] = content[0]['servings']
    @results[:description] = content[0]['summary'].gsub(/<\/?[^>]+>/, '')
    @results[:recipe] = content[0]["instructions"].gsub(/<\/?[^>]+>/, '').gsub("\n", '') # returns string
    @results[:time_to_cook] = content[0]["readyInMinutes"] # returns integer, turn to stirng if needed?
    @results[:url] = content[0]['sourceUrl']
    @results
  end

  def user_recipe(*)
    @res0ults = RecipeCard.new(:name, :serves, :description, :time_to_cook, :recipe, :url)
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

  def filter(num, parameter)
    read_recipes[num][parameter]
  end
end

request = Api.new
# request.write_recipes
request.read_recipes
request.filter(3, 'name')
p request.user_recipe('0tim', 4, 'tiny tim', '20 mins', 'put him in the oven', 'www.tinytim.com')
p request
