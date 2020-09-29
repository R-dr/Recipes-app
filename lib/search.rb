require 'faraday'
require 'json'
require 'tty-prompt'
require 'byebug'


module RecipeHelper
  File_path = "../public/recipes.json"
  PROMPT = TTY::Prompt.new
end

class Api
  include Faraday
  include RecipeHelper
  @@api_root = "https://api.spoonacular.com"
  @@api_key = "?apiKey=945916246cc3460dbfe56c71616e4d96"

  def initialze # (term, parameter)
    @term = term
  end

  def search
     parsed_hash = JSON.parse(Faraday.get("#{@@api_root}/recipes/random#{@@api_key}").body)
    content = parsed_hash["recipes"]
    @results = {}
    @results[:name] = content[0]["title"] # returns string
    @results[:serves] = content[0]['servings']
    @results[:description] = content[0]['summary'].gsub(/<\/?[^>]+>/, '')
    @results[:recipe] = content[0]["instructions"].gsub(/<\/?[^>]+>/, '').gsub("\n", '') # returns string, need to gsub(/n,"")
    @results[:time_to_cook] = content[0]["readyInMinutes"] # returns integer, turn to stirng if needed?
    @results[:url] = content[0]['sourceUrl']
    @results
  end

  def write_recipes
    @@file = read_recipes
    @@file << @results
    File.write(File_path, JSON.pretty_generate(@@file))
  end

  def read_recipes
    file = File.read(File_path)
    file_hash = JSON.parse(file)
    file_hash
  end
  def filter(num,parameter)
     read_recipes[num][parameter]
    end

    
end

request = Api.new
#request.write_recipes 
request.read_recipes
 p request.filter(3,'name')