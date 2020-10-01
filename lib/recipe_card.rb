require_relative 'recipehelper'
require 'tty-prompt'
class RecipeCard
  include RecipeHelper
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
 def split_ingredients(ingredients)
  ingredients.split(' ')
  end
  def to_a
    [@name, @serves, @description, @ingredients, @recipe, @time_to_cook, @url]
  end
  def self.user_recipe
    recipe = {}
    HEADERS.each do |input|
      puts "Type out your ingredients separated with spaces eg. banana shrimp" if input == :ingredients
      puts "You dont need to enter a url but it migh be nice for inspiration?" if input == :url
      puts "Whats the #{input}?"
      print '> '
      recipe[input] = gets.chomp
    end
    
    recipe
  end
end
