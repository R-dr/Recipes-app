require_relative 'search'
require_relative 'recipehelper'
require 'byebug'
require 'JSON'
require_relative 'recipe_card'
class RecipeBook 
  include RecipeHelper
  attr_accessor :book
  def initalize
    @book = read_recipes
  end
  def read_recipes
    file_hash = JSON.parse(File.read(RECIPES_PATH))
    file_hash
    
  end
  
byebug
  def show_titles
    @book.map{ |recipe| recipe['name'] }
  end
end
test = RecipeBook.new
 test.read_recipes
p test.read_recipes
 test.show_titles
