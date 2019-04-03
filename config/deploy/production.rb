set :default_env, { rack_env: fetch(:stage) }

srv = ENV.fetch("REMOTE_SRV", "www.jaylen.com.ar")
usr = ENV.fetch("REMOTE_USR", "cristian")
server srv, user: usr, roles: %w{app}

set :ssh_options, {
   port: 22,
   keys: ["#{ENV['HOME']}/.ssh/id_rsa"],
   forward_agent: true,
   auth_methods: %w(publickey)
}
