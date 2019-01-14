require "roda"
require "tilt/erubis"
require_relative "config/initializers/dotenv"
require_relative "lib/picture"

class App < Roda
  plugin :environments
  plugin :path
  path :root, "/"
  path :folder do |folder|
    "/#{folder}"
  end
  plugin :render
  opts[:public] = "public/system"
  plugin :assets, css: %w(bootstrap.css style.css unite-gallery.css),
                  js: %w(jquery.js popper.js bootstrap.js unitegallery.js ug-theme-tiles.js),
                  js_compressor: :closure,
                  public: opts[:public],
                  precompiled: File.join(opts[:public], "assets.json"),
                  gzip: true
  plugin :content_for

  configure :development do
    plugin :static, ["/#{Picture::DIR.basename}"], root: Picture::DIR.parent
    plugin :static, %w(/img), root: "assets"
  end

  configure :production do
    use Rack::Auth::Basic, "Restricted Area" do |_, password|
      password == ENV["PASSWD"]
    end
  end

  route do |r|
    r.assets unless self.class.production?

    r.get do
      r.is String do |folder|
        view "show", locals: { pictures: Picture.from_folder(folder) }
      end

      r.root do
        folders = Picture.folders
        view "index", locals: { folders: folders }
      end
    end
  end

  def group_folders_by_year(folders)
    @folders_by_year ||= folders.map { |folder| Picture.parse_date(folder) }.
                                 reject { |dt, _| !dt }.
                                 group_by(&:year)
  end

  Dir["helpers/*.rb"].each { |helper| require_relative helper }
end
