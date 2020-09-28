require 'faraday'
require 'json'
require 'tty-prompt'
require 'byebug'

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
       @json_string = Faraday.get("#{@@api_root}/recipes/random#{@@api_key}").body
       @json_hash = JSON.parse(@json_string)
        parsed_hash = @json_hash
        content = parsed_hash["recipes"]
        @results = {}
        @results[:name] = content[0]["title"] # returns string
        @results[:serves] = content[0]['servings']
        @results[:description] = content[0]['summary'].gsub(/<\/?[^>]+>/, '')
        @results[:recipe] = content[0]["instructions"].gsub(/<\/?[^>]+>/, '').gsub("\n",'') #returns string, need to gsub(/n,"")
        @results[:time_to_cook] = content[0]["readyInMinutes"] # returns integer, turn to stirng if needed?
        @results[:url] = content[0]['sourceUrl']
        @results
        
    end
      
  def write_recipes
    File.write("../public/recipes.json",JSON.pretty_generate(@results),mode: "a")
  end
    def read_recipes
     temp = File.read("../public/recipes.json")
      JSON.parse(temp)
    end
  end

request = Search.new
request.search
 p request.read_recipes