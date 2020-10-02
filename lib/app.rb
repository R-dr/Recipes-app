require 'terminal-table'
require 'colorize'
require 'json'
require_relative 'api'
require_relative 'menu'
require_relative 'recipe_card'

menu = Menu.new
menu.choices

