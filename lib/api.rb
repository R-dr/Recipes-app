require 'faraday'
require 'json'
require 'tty-prompt'
require 'byebug'
require_relative 'recipe_card'
require_relative 'recipehelper'


class Api
  attr_reader :results
  include Faraday
  include RecipeHelper
  # API key and root for visibilty change api key value should you wish to create your own account at www.spoonacular.com
  @@api_root = "https://api.spoonacular.com"
  @@api_key = "?apiKey=945916246cc3460dbfe56c71616e4d96"
  
  def initialze
    @recipebook = read_recipes
  end
  def search_random_recipe
    content = JSON.parse(Faraday.get("#{@@api_root}/recipes/random#{@@api_key}").body)["recipes"]
    convert_api_data(content)
  end
  # converts the parsed data from the faraday response into a workable object for the app to read and write
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
 # makes ingredients into an array so they are displayed when the user wants to view a recipe 
  def split_ingredients(ingredients)
    ingredients.split(' ')
  end
  # method for user recipe to be writen to recipe book then saved
  def get_user_recipe
    recipe = RecipeCard.user_recipe
    recipebook = read_recipes
     recipebook << RecipeCard.new(
       recipe[:name],
       recipe[:serves],
       recipe[:description],
       recipe[:recipe],
       recipe[:ingredients],
       recipe[:time_to_cook],
       recipe[:url]
     )
     
     file = read_recipes
     recipe[:ingredients] = recipe[:ingredients].split(' ')
     recipe.each_value do |value| if value.length < 1 
      puts 'Recipe not saved, you need to enter something for each input'
    end 
    end
     file << recipe
       File.write(RECIPES_PATH, JSON.pretty_generate(file))
    end
  # method for writing the users recipe
  def write_user_recipe
    data = @recipebook.map do |card|
      {
        name: card.name,
        serves: card.serves,
        description: card.description,
        ingredients: card.ingredients,
        recipe: card.recipe,
        time_to_cook: card.time_to_cook,
        url: card.url
      }
    end
    file = read_recipes
    file << data
      File.write(RECIPES_PATH, JSON.pretty_generate(file))
  end
  # writes api recipes into JSON file
  def write_recipes
    @file = read_recipes
    @file << @results
        File.write(RECIPES_PATH, JSON.pretty_generate(@file))
  end
# parses JSON file and reads them so the app can generate the recipes onto the screen
  def read_recipes
    file_hash = JSON.parse(File.read(RECIPES_PATH))
    file_hash
    
  end
  # displays temporary recipe afterwards user is prompted to save or not recipe only exists in app memory at this point
  def show_last_recipe(last_recipe)
    res = @results
    rows = []
    rows << [res[:name]] 
      table = Terminal::Table.new headings: header = ['name'], rows: rows
    puts table
    puts res[:ingredients].map{|item|item}
    puts "
    ".colorize( :background => :red)
    puts "Description"
    puts res[:description]
    puts "
    ".colorize( :background => :red)
    puts 'Recipe'
    puts res[:recipe]  
    puts "
    ".colorize( :background => :red)
    puts res[:url]  
 end
 # fix if the user deletes all recipes or deletes recipe.json file
 def reset
  content = JSON.parse(Faraday.get("#{@@api_root}/recipes/random#{@@api_key}").body)["recipes"]
  reset_book = convert_api_data(content)
  file = []
  file << reset_book
  File.write(RECIPES_PATH, JSON.pretty_generate(file))
 end
end