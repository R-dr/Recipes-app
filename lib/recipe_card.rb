 class RecipeCard
  attr_reader :title, :serves, :description, :recipe, :time_to_cook, :url
  def initialize(title, serves, description, time_to_cook, recipe, url )
    @title = title
    @serves = serves
    @description = description
    @recipe = recipe
    @time_to_cook = time_to_cook
    @url = url
  end
  def to_a
    [@title, @serves, @description, @time_to_cook, @recipe, @url]
  end

end