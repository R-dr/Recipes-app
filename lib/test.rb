
def search_complex_search
  parsed_hash = JSON.parse(Faraday.get("https://api.spoonacular.com/recipes/complexSearch?apiKey=945916246cc3460dbfe56c71616e4d96&query=tuna").body)
  content = parsed_hash["recipes"]
  @results = {}
  @results[:name] = content[0]["title"] # returns string
  @results[:serves] = content[0]['servings']
  @results[:description] = content[0]['summary'].gsub(/<\/?[^>]+>/, '')
  @results[:recipe] = content[0]["instructions"].gsub(/<\/?[^>]+>/, '').gsub("\n", '') # returns string
  @results[:time_to_cook] = content[0]["readyInMinutes"] # returns integer, turn to stirng if needed?
  @results[:url] = content[0]['sourceUrl']
  @results
en
def display_menu 
  PROMPT.select("Congratulations on making it this far! By my count you missed 300 bugs on the way!") do |menu|
    menu.choice({name:'View saved recipes', value:'1'})
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

  def exit_mode
      PROMPT.select('Are you sure? would you like to save your Recipes?')
      menu.choice({name:'Just quit already!', value:'1'})
      menu.choice({name:'Quit and save my recipes! please?', value:'2'})
      menu.choice({name:'Wait no it was a mistake take me back!', value:'3'})
  end
  case exit_mode 
  when '1'
    exit
  when '2'
    @recipebook.write_recipes
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