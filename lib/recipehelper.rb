module RecipeHelper
  path = File.dirname(__FILE__).split("/")
  path.pop
  RECIPES_PATH = "#{path.join("/")}/public/recipes.json"
  PROMPT = TTY::Prompt.new
  HEADERS = %i[name serves description ingredients recipe time_to_cook url]
  def select_recipe(num)
    read_recipes[num].map do |k,r| 
  puts "#{k}"
  puts ""
  puts "#{r}"
  end
end
end