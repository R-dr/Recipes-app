require_relative 'recipe_card'
require_relative 'api'
require 'terminal-table'
require 'colorize'
require_relative 'recipehelper'
require 'faraday'
# menu, access data and extract the data then display the data in a readable format
class Menu 
  include RecipeHelper
   def initialize
    @recipebook = JSON.parse(File.read(RECIPES_PATH))
    @new_recipe = Api.new
    
  end
  
  def display_menu 
    faraday_return = Faraday.get('https://api.spoonacular.com/food/jokes/random?apiKey=945916246cc3460dbfe56c71616e4d96')
    query_counter = faraday_return.headers["x-api-quota-used"]
    query_use = faraday_return.headers["x-api-quota-request"]
    joke =JSON.parse(faraday_return.body)['text']
    puts "
    ".colorize( :background => :white)
    PROMPT.select("#{joke} 
      your counter is at #{query_counter} out of 150 for the day, this search used #{query_use}, just remember each recipe takes about 1 point") do |menu|
      menu.choice({name:'View saved recipes', value:'1'})
      menu.choice({name:'Find a random recipe! Live a little! Cremebrulee for dinner?', value:'2'})
      menu.choice({name:'Write your own recipe', value:'3'})
      menu.choice({name:"Can't decide but have food in the house? filter your saved recipes based on what you've got!", value:'4'})
      menu.choice({name:'Exit', value:'5'})
    end 
  end
  #######################
  ##saved recipes route##
  #######################
  def terminal_table_lander(list)
    header = ['number' , 'name', 'serves']
    i = 1
    rows = []
    list.each do |recipe|
        rows << [i] + [ recipe["name"]] + [recipe["serves"] ]
        i += 1
      end
        table = Terminal::Table.new headings: header, rows: rows, :style => {:width => 80}
        puts table
      choose_recipe(list)
  end
  def choose_recipe(arr)
    puts 'please select a recipe by number to display'
    print 'number? '
    number = gets.chomp.to_i
    display_recipe(number,arr)
  end

  def display_recipe(num, list)
   terminal_key = list[num-1]
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
######################
###new recipe route###
######################
def search_new_recipe
    @new_recipe.search_random_recipe
    terminal_table_new_recipe(@new_recipe.results)
  end
  def search_targeted_recipe
    puts 'what do you feel like? This search can take things like say "fish pasta eggs or even bagels!" just dont go entering number or anything and you\'re golden'
    #target = gets.chomp.downcase!
    
    #puts 'what did i just say? two seconds ago? no numbers or symbols, got it?'if letter_check(target)
    terminal_table_lander(filtered_results)
  end
  def filtered_results
    search_para = gets.chomp
    result = []
    @new_recipe.read_recipes.each do|recipe|
       if recipe['ingredients'].join(' ').include? search_para
        result << recipe
       end
      end
      result
  end



  #######################
  ##checking user input##
  #######################
  def letter_check(str)
    str[/[a-z]+/]  == str
  end
  #basically an if check that returns true if there is only letters

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
        @new_recipe.show_last_recipe(@new_recipe.read_recipes)
       save_random_recipe
      when '2'
        search_new_recipe
      when '3'
        exit
      end
    end
    def save_random_recipe
      if PROMPT.yes?('Do you want to save this recipe?')
        @new_recipe.write_recipes
       
      else 
        choices
      end
    end
    
    def save_recipe
      case view_recipe_choice
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
        terminal_table_lander(@new_recipe.read_recipes)
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
