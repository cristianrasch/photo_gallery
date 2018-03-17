require "pathname"
require "set"
require_relative "../config/initializers/dotenv"

class Picture
  PUBLIC_DIR = Pathname(ENV.fetch("PUBLIC_DIR"))
  WEB_SUBDIR = -"web"
  THUMB_SUBDIR = -"thumb"
  EXTENSIONS = ENV.fetch("PHOTO_EXT").split(",").freeze

  class << self
    def folders
      @folders ||= SortedSet.new(PUBLIC_DIR.expand_path.children.
                                                  select(&:directory?).
                                                  map { |path|
                                                    path.basename.to_s
                                                  }.
                                                  sort)
    end

    def from_folder(folder)
      return [] unless folders.include?(folder)

      exts = EXTENSIONS.map { |ext| File.join(folder, WEB_SUBDIR, "*.#{ext}") }
      Dir[*exts, base: PUBLIC_DIR.expand_path].
        map { |pic_path| new("/#{PUBLIC_DIR.basename.join(pic_path)}") }
    end
  end

  attr_reader :path

  def initialize(path)
    @path = Pathname(path)
  end

  def thumb_fname
    dir, file = path.split
    dir.sub(WEB_SUBDIR, THUMB_SUBDIR).join(file)
  end
end
