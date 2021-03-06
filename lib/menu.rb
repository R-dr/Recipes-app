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
  # menu where user choses what to do, is refreshed through choices every time the user completes a loop
  def display_menu 
    faraday_return = Faraday.get('https://api.spoonacular.com/food/jokes/random?apiKey=945916246cc3460dbfe56c71616e4d96')
    query_counter = faraday_return.headers["x-api-quota-used"]
    query_use = faraday_return.headers["x-api-quota-request"]
    joke =JSON.parse(faraday_return.body)['text']
    puts "
    ".colorize( :background => :white)
    PROMPT.select("#{joke} 
      your counter is at #{query_counter} out of 150 for the day, this search used #{query_use},
       just remember each recipe takes about 1 point and refreshing this menu takes 1 point, you get 150 a day so you should be fine.") do |menu|
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
  # displays recipes in table format
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
      if PROMPT.yes?('do you want to delete a recipe?') 
         delete_saved_recipe(list) 
      else 
        choose_recipe(list)
      end
  end
  # user is prompted to delete a recipe or not, this was the simplest implementation of this so it occurs before they make a selection to view a recipe 
  def delete_saved_recipe(arr)
    puts 'please enter the recipe number'
    print ' >'
    num = gets.chomp.to_i
    if num - 1 > arr.length
      puts "no recipe found"
      choices
    end
    arr.delete_at(num-1)
    File.write(RECIPES_PATH, JSON.pretty_generate(arr))
    choices
  end
  # user is prompted to chose a recipe based on index -1 formula to display recipe
  def choose_recipe(arr)
    puts 'please select a recipe by number to display'
    print 'number? '
    number = gets.chomp.to_i
    display_recipe(number,arr)
  end
# user choses a recipe based on the index value +1 stored in i which is displayed beside the recipes on the table 
  def display_recipe(num, list)
    
   terminal_key = list[num-1]
    rows = []
    rows << [terminal_key['name']] 
      table = Terminal::Table.new headings: header = ['name'], rows: rows
    puts table
    puts 'Ingredients'.colorize(:color => :white, :background => :red)
    puts terminal_key['ingredients'].map{|item|item}
    puts "
    ".colorize( :background => :red)
    puts "Description".colorize(:color => :white, :background => :red)
    puts terminal_key['description']
    puts "
    ".colorize( :background => :red)
    puts 'Recipe'.colorize(:color => :white, :background => :red)
    puts terminal_key['recipe']
    puts "
    ".colorize( :background => :red)
    puts terminal_key['url']
  end
######################
###new recipe route###
######################
# uses api to display random recipe
  def search_new_recipe
    @new_recipe.search_random_recipe
    terminal_table_new_recipe(@new_recipe.results)
  end
  #filters saved recipes based on a search term, returns a message if there is no recipe with that term  

  def search_targeted_recipe
    puts 'what do you feel like? This search can take things like say "fish pasta eggs or even bagels!" just dont go entering numbers or anything and you\'re golden'
    terminal_table_lander(filtered_results)
  end
  # takes the search term and stores the result in an array so that it can be displayed in a table format
  def filtered_results
    search_para = gets.chomp
    result = []
    unless letter_check(search_para)
      puts 'it seems like you entered a number or a symbol, dont do that..'
      search_targeted_recipe
    end
    @new_recipe.read_recipes.each do|recipe|
       if recipe['ingredients'].join(' ').downcase!.include? search_para
        result << recipe
       end
      end
      if result.empty?
       puts "Sorry  you don't have any recipes with those items, please try again."
       choices
      end
      result
  end



  #######################
  ##checking user input##
  #######################
  #basically an if check that returns true if there is only letters used in filtered results 
  def letter_check(str)
    str[/[a-z]+/]  == str
  end
# stores the recipe in app memory before prompting the user to view
  def terminal_table_new_recipe(api_recipe)
    header = ['name', 'serves']
    rows = [[api_recipe[:name]] + [api_recipe[:serves]]]
     
     table = Terminal::Table.new headings: header, rows: rows
      puts table
      view_recipe_choice
  end
  # where the user can choose to view the new recipe or search again after viewwing the user can decide if they want to save it at that point to the recipes.JSON file
  def view_recipe
    PROMPT.select('want to see the recipe?') do |menu|
      menu.choice({name:'yes', value:'1'})
      menu.choice({name:'no, search again', value:'2'})
      menu.choice({name:'no, quit', value:'3'})
    end
  end
  # router to either view or search again, user may exitt at this point as well
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
    # user is prompted to save the new recipe
    def save_random_recipe
      if PROMPT.yes?('Do you want to save this recipe?')
        @new_recipe.write_recipes
       
      else 
        choices
      end
    end
    #this takes the return of the view recipe choice and acts accordingly
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
     
# apps main logic router 
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



