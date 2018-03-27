set :output, "log/whenever.log"
set :environment_variable, "RACK_ENV"
rack_env = ENV.fetch("RACK_ENV", "production")
set :environment, rack_env.to_sym

every :day do
  script "generate_thumbnails -c 2"
end
