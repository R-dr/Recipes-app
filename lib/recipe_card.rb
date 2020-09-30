class RecipeCard
  attr_reader :name, :serves, :description, :ingredients, :recipe, :time_to_cook, :url
  def initialize(name, serves, description, ingredients, recipe, time_to_cook, url)
    @name = name
    @serves = serves
    @description = description
    @ingredients = ingredients
    @recipe = recipe
    @time_to_cook = time_to_cook
    @url = url
  end

  def to_a
    [@name, @serves, @description, @ingredients, @recipe, @time_to_cook, @url]
  end
  
end
