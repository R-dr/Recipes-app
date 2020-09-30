require_relative 'recipe_card'
require_relative 'search'
require 'terminal-table'
require 'colorize'
require_relative 'recipehelper'
# menu, access data and extract the data then display the data in a readable format
class Menu < Api
  include RecipeHelper
  # include FridgeFilter
  def initialize
    @recipebook = Api.new
  end

  def display_menu
    PROMPT.select("Congratulations on making it this far! By my count you missed 300 bugs on the way!") do |menu|
      menu.choice 'View saved recipes',  '1' 
      menu.choice 'Find a random recipe! Live a little! Cremebrulee for dinner?', '2' 
      menu.choice 'Write your own recipe', '3' 
      menu.choice "Can't decide but have food in the fridge? filter based on what you've got!", '4'
      menu.choice 'Exit', '5'
    end
  end
  def choices
    case display_menu
     when '1'
       @recipebook.show_recipes
     when '2'
       @recipebook.search_api_recipes
     when '3'
       @recipebook.user_recipe
     when '4'
       @recipebook.fridge
     when '5'
       exit_mode
     end
   end
  


end

menu = Menu.new
menu.choices
