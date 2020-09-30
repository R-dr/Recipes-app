class RecipeCard
  attr_reader :name, :serves, :description, :recipe, :time_to_cook, :url
  def initialize(name, serves, description, time_to_cook, recipe, url)
    @name = name
    @serves = serves
    @description = description
    @recipe = recipe
    @time_to_cook = time_to_cook
    @url = url
  end

  def to_a
    [@name, @serves, @description, @time_to_cook, @recipe, @url]
  end
  
end
