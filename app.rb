require "roda"
require_relative "config/initializers/dotenv"
require_relative "lib/picture"

class App < Roda
  plugin :environments
  plugin :path
  path :root, "/"
  path :folder do |folder|
    "/#{folder}"
  end
  # plugin :empty_root
  plugin :render
  opts[:public] = "public/system"
  plugin :assets, css: Dir.chdir("assets/css") { Dir["**/*.css"] },
                  js: Dir.chdir("assets/js") { Dir["**/*.js"] },
                  public: opts[:public],
                  precompiled: File.join(opts[:public], "assets.json"),
                  gzip: true
  plugin :content_for

  configure :development do
    plugin :static, Picture.folders.map { |folder| "/#{folder}/" },
                    root: Picture::PUBLIC_DIR
  end

  configure :production do
    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == ENV["USR"] && password == ENV["PASSWD"]
    end
  end

  route do |r|
    r.assets unless self.class.production?

    r.get do
      r.is String do |folder|
        view "folders/show", locals: { pictures: Picture.from_folder(folder) }
      end

      r.root do
        view "index", locals: { folders: Picture.folders }
      end
    end
  end
end
