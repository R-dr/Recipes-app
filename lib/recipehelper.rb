module RecipeHelper
  path = File.dirname(__FILE__).split("/")
  path.pop
  RECIPES_PATH = "#{path.join("/")}/public/recipes.json"
  PROMPT = TTY::Prompt.new
end