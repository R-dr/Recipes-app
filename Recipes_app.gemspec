
Gem::Specification.new do |s|
  s.name = 'Recipes_app'
  s.version = '1.0.0'
  s.date = '2020-10-04'
  s.summary = 'Recipes_app generates random recipes for users '
  s.files = [
    'lib/api.rb',
    'lib/menu.rb',
    'lib/recipe_card.rb',
    'lib/recipehelper.rb',
    'public/recipes.json'
  ]
  s.require_paths = %w[lib public]
  s.authors = ['Rodney Ditchfield']
  s.executables << 'Recipes_app'
  s.required_ruby_version = '>= 2.4'
  s.add_runtime_dependency 'tty-prompt'
  s.add_runtime_dependency 'terminal-table'
  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'colorize'
end