require_relative 'recipe_card'
require_relative 'search'
require 'terminal-table'
require 'colorize'
require_relative 'recipehelper'
# menu, access data and extract the data then display the data in a readable format
class Menu 
  include RecipeHelper
  # include FridgeFilter
  def initialize
    @recipebook = JSON.parse(File.read(RECIPES_PATH))
  end
  
  def display_menu 
    PROMPT.select("Congratulations on making it this far! By my count you missed 300 bugs on the way!") do |menu|
      menu.choice({name:'View saved recipes', value:'1'})
      menu.choice({name:'Find a random recipe! Live a little! Cremebrulee for dinner?', value:'2'})
      menu.choice({name:'Write your own recipe', value:'3'})
      menu.choice({name:"Can't decide but have food in the fridge? filter based on what you've got!", value:'4'})
      menu.choice({name:'Exit', value:'5'})
    end 
  end
  def terminal_table
    header = gets.chomp.split(' ')
    rows = []
    para = header.map{|param|param}
      @recipebook.each do |recipe|
        rows << [recipe["name"]] + [recipe["serves"]]
      end
      byebug
        table = Terminal::Table.new headings: para, rows: rows, :style => {:width => 80}
        puts table
    
  end
  
  
  def choices
    loop do
      case display_menu
      when '1'
        
        terminal_table
      when '2'
        #@recipebook.search_random_recipe
      when '3'
        @recipebook.user_recipe
      when '4'
        @recipebook.fridge
      when '5'
        
        exit
      end
    end
   
  end
end

menu = Menu.new
menu.choices
