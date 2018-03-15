set :default_env, { rack_env: fetch(:stage) }

server "www.jaylen.com.ar", user: "cristian", roles: %w{app}

set :ssh_options, {
   port: 22,
   keys: ["#{ENV['HOME']}/.ssh/id_rsa"],
   forward_agent: true,
   auth_methods: %w(publickey)
}
