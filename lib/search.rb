require 'faraday'
require 'json'
require 'tty-prompt'
require 'byebug'
require 'nokogiri'
module RecipeHelper
  path = File.dirname(__FILE__).split("/")
  path.pop
  RECIPE_DATABASE = "#{path.join("/")}/public/recipes.json"
  PROMPT= TTY::Prompt.new
end

class Search
    include Faraday
    include RecipeHelper
    @@api_root = "https://api.spoonacular.com"
    @@api_key = "?apiKey=945916246cc3460dbfe56c71616e4d96"

      def initialze#(term, parameter)
        @term = term
        
      end

    def search
       @json_string = Faraday.get("#{@@api_root}/recipes/random#{@@api_key}")
       JSON.parse(@json_string)
       byebug
        pp @json_string.to_s
       
       parsed_hash = @json_string
       @results = {}
       @results[:cuisines] = parsed_hash["cuisines"] #returns array
       @results[:name] = parsed_hash["title"] # returns string
       @results[:recipe] = parsed_hash["instructions"] #returns string, need to gsub(/n,"")
       @results[:time_to_cook] = parsed_hash["readyInMinutes"] # returns integer, turn to stirng if needed?
       json_hash
    end
      
  def write_recipes
    File.write("../public/recipes.json",JSON.pretty_generate(@json_string))
  end
    def show
     "#{@result}"
    end
end
request = Search.new
request.search
request.write_recipes