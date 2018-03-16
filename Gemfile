# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "roda"
gem "tilt"
gem "erubis"
gem "dotenv"
gem "mini_magick"
gem "puma"
gem "rake"

group :development do
  gem "rerun"
  gem "capistrano"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
  gem "capistrano3-puma"
end

group :production do
  gem "yui-compressor"
end
