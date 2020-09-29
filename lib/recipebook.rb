require_relative 'search'
require_relative 'recipe_card'
class RecipeBook
  include RecipeHelper
  attr_reader :book
  def initalize
    @book = read_recipes
  end

  def read_recipes
    file = File.read(File_path)

    JSON.parse(file).map do |recipe|
      byebug
      i = 0
      RecipeCard.new(
        recipe[i]['name'],
        recipe[i]['serves'],
        recipe[i]['description'],
        recipe[i]['recipe'],
        recipe[i]['time_to_cook'],
        recipe[i]['url']
      )
    end
    i += 1
  end

  def self.show_titles
    @book.map { |recipe| recipe['title'] }
  end
end
test = RecipeBook.new
p test.read_recipes
