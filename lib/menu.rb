require_relative 'recipe_card'
require_relative 'api'
require 'terminal-table'
require 'colorize'
require_relative 'recipehelper'
require 'faraday'
# menu, access data and extract the data then display the data in a readable format
class Menu 
  include RecipeHelper
  # include FridgeFilter
  def initialize
    @recipebook = JSON.parse(File.read(RECIPES_PATH))
    @new_recipe = Api.new
    
  end
  
  def display_menu 
    joke =res = JSON.parse(Faraday.get('https://api.spoonacular.com/food/jokes/random?apiKey=945916246cc3460dbfe56c71616e4d96').body)['text']
    puts "
    ".colorize( :background => :white)
    PROMPT.select(joke) do |menu|
      menu.choice({name:'View saved recipes', value:'1'})
      menu.choice({name:'Find a random recipe! Live a little! Cremebrulee for dinner?', value:'2'})
      menu.choice({name:'Write your own recipe', value:'3'})
      menu.choice({name:"Can't decide but have food in the house? filter based on what you've got!", value:'4'})
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
      table = Terminal::Table.new headings: header = ['name'], rows: rows
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
    terminal_table_new_recipe(@new_recipe.results)
  end
  def search_targeted_recipe
    puts 'what do you feel like? This search can take things like say "fish pasta eggs or even bagels!" just dont go entering number or anything and you\'re golden'
    target = gets.chomp.downcase!
    puts 'what did i just say? two seconds ago? no numbers got it?'if letter_check( target)
    @new_recipe.search_complex_search(target)
    terminal_table_new_recipe(@new_recipe.results)
  end
  def letter_check(str)
    str[/[a-zA-Z]+/]  == str
  end
  def terminal_table_new_recipe(api_recipe)
    header = ['name', 'serves']
    rows = [[api_recipe[:name]] + [api_recipe[:serves]]]
     
     table = Terminal::Table.new headings: header, rows: rows
      puts table
      view_recipe_choice
  end
  def view_recipe
    PROMPT.select('want to see the recipe?') do |menu|
      menu.choice({name:'yes', value:'1'})
      menu.choice({name:'no, search again', value:'2'})
      menu.choice({name:'no, quit', value:'3'})
    end
  end
    def view_recipe_choice
      case view_recipe
      when '1'
       @new_recipe.show_last_recipe(@new_recipe.results)
       save_recipe
      when '2'
        search_new_recipe
      when '3'
        exit
      end
    end
    
    def save_recipe_choice
      PROMPT.select('want to save this recipe?') do |menu|
        menu.choice({name:'yes', value:'1'})
        menu.choice({name:'no, search again', value:'2'})
        menu.choice({name:'no, quit', value:'1'})
        end
    end
    def save_recipe
      case save_recipe_choice
      when '1'
        @new_recipe.write_recipes
      when '2'
        search_new_recipe
      when '3'
        exit
      end
    end
     

  def choices
    loop do
      case display_menu
      when '1'
        terminal_table_lander
      when '2'
        search_new_recipe
      when '3'
        @new_recipe.get_user_recipe
      when '4'
        search_targeted_recipe
      when '5'
         exit
      end
    end
   
  end
end


menu = Menu.new
menu.choices
