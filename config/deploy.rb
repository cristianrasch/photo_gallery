# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :rbenv_ruby, File.read(".ruby-version").chomp!

set :application, "photo_gallery"
set :repo_url, "git@www.jaylen.com.ar:#{fetch(:application)}.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :whenever_environment, ->{ fetch(:stage) }
set :whenever_roles, %w(app)

namespace :deploy do
  namespace :assets do
    desc 'Precompile static assets'
    task :precompile do
      on roles(:app) do
        execute "cd #{release_path} &&  RACK_ENV=#{fetch(:stage)} ~/.rbenv/bin/rbenv exec bundle exec rake assets:precompile"
      end
    end
  end
  after  :publishing, :"assets:precompile"
end

namespace :app do
  task :restart do
    on roles(fetch(:puma_role)) do
      execute :sudo, "systemctl restart #{fetch(:application)}"
    end
  end
end
