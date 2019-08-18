# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "roda"
gem "tilt"
gem "erubis"
gem "dotenv"
gem "mini_magick"
gem "puma", "~> 3.12"
gem "rake"
gem "whenever", require: false
gem "tzinfo"

group :development do
  gem "rerun"
  gem "capistrano"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
  gem "capistrano3-puma"
end

group :test do
  gem "minitest"
  gem "rack-test"
end

group :production do
  gem "yuicompressor"
  gem "closure-compiler"
end
