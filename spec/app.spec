# gems
require 'terminal-table'
require 'colorize'
require 'json'
require 'optparse'
require 'rspec'
# files
require_relative '../lib/api'
require_relative '../lib/menu'
require_relative '../lib/recipe_card'
#arrange
#act
#assert

RSpec.describe 'Menu shows last recipe' do
    it 'Menu displays last recipe' do
    #Arrange
    test_menu = Menu.new
    #assert
    test_recipe = menu.show_last_recipe

     p expect(test_recipe).to eq(menu.read_recipes[-1])
end
    it "user can add recipe" do
    #Arrange
    test_recipe = Api.new 
    test_recipe.write_user_recipe
    #Assert
    p expect(test_recipe).to eq(RecipeCard.new)
    end

end