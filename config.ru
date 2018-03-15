#\ -s puma

require_relative "app"

run ENV["RACK_ENV"] == "production" ? App.freeze.app : App
