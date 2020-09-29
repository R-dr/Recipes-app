require_relative 'recipe_card'
require_relative 'search'
require 'terminal-table'
require 'colorize'
# menu, access data and extract the data then display the data in a readable format
class Menu
  #Colorize_val = :color => :black, :background => :white
  include RecipeHelper
  include FridgeFilter
  def initialize
    @recipebook = Api.new
  end

  def welcome_text
    puts "welcome to Recipe Finder 2000".colorize(:color => :black, :background => :white)
    puts "".colorize(:background => white)
    puts "this currently has more bugs then bethesda".colorize(:color => :black, :background => :white)
    puts " I hope you bought a can of Raid".colorize(:color => :black, :background => :white)
  end
   byebug
  def display menu 
    PROMPT.select("Congratulations on making it this far! By my count you missed 300 bugs on the way!") do |menu|
      menu.choice({name:'View saved reipes', value:'1'})
      menu.choice({name:'Find a random recipe! Live a little! Cremebrulee for dinner?', value:'2'})
      menu.choice({name:'Write your own recipe', value:'3'})
      menu.choice({name:"Can't decide but have food in the fridge? filter based on what you've got!", value:'4'})
      menu.choice({name:'Exit', value:'5'})
    end
  end
  def table_display
    rows = @recipebook.map do |recipe|
      recipe.to_a
    end
    table = Terminal::Table.new({headings: INPUT,rows: rows})
    puts table
  end
  def choices
    loop do 
      case menu
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

    def exit_mode
        PROMPT.select('Are you sure? would you like to save your Recipes?')
        menu.choice({name:'Just quit already!', value:'1'})
        menu.choice({name:'Quit and save my recipes! please', value:'2'})
        menu.choice({name:'Wait no it was a mistake take me back!', value:'3'})
    end
    case exit_mode 
    when '1'
      exit
    when '2'
      @recipebook::write_recipes
    when '3'
      menu
    end
  end



  def show_recipes
    i = 0
    while i < @recipebook.length

      @recipebook.map { |recipe| recipe[i] }
      i += 1
      byebug
    end
  end
end
menu = Menu.new
p menu.welcome_text
