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
    @new_recipe = Api.new
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
  def terminal_table_lander
    header = ['number' , 'name', 'serves']
    i = 1
    rows = []
    para = header.map{|param|param}
      @recipebook.each do |recipe|
        rows << [i] + [ recipe["name"]] + [recipe["serves"] ]
        i += 1
      end
        table = Terminal::Table.new headings: header, rows: rows, :style => {:width => 80}
        puts table
      choose_recipe
  end
  def choose_recipe
    puts 'please select a recipe by number to display'
    print 'number? '
    number = gets.chomp.to_i
    display_recipe(number)
  end

  def display_recipe(num)
   terminal_key = @recipebook[num-1]
    rows = []
    rows << [terminal_key['name']] 
      table = Terminal::Table.new headings: header = ['name'], rows: rows#, :style => {:width => 80}
    puts table
    puts terminal_key['ingredients'].map{|item|item}
    puts "
    ".colorize( :background => :red)
    puts "Description"
    puts terminal_key['description']
    puts "
    ".colorize( :background => :red)
    puts 'Recipe'
    puts terminal_key['recipe']
  end
  def search_new_recipe
    @new_recipe.search_random_recipe
    @new_recipe.write_recipes
    terminal_table_new_recipe(@new_recipe.results)
  end
  def terminal_table_new_recipe(api_recipe)
    header = ['name', 'serves']
    rows = [[api_recipe[:name]] + [api_recipe[:serves]]]
     
     table = Terminal::Table.new headings: header, rows: rows#, :style => {:width => 80}
      puts table
      view_recipe
  end
  def view_recipe
    PROMPT.yes?('want to see the recipe?') do |q|
      q.positive 'yes'
      q.negative 'no'

  def choices
    loop do
      case display_menu
      when '1'
        
        terminal_table_lander
      when '2'
        search_new_recipe
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
