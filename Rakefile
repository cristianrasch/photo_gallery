require "rake/testtask"
Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.verbose = true
end
task default: :test

namespace :assets do
  desc "Precompile the assets"
  task :precompile do
    require_relative "app"
    App.compile_assets
  end
end
