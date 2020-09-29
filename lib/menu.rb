require_relative 'recipe_card'
require_relative 'search'
#menu, access data and extract the data then display the data in a readable format
class Menu
  include RecipeHelper
 def  initialize
   @recipebook = RecipeBook.new
 end
end
