require "pathname"
require "set"
require_relative "../config/initializers/dotenv"

class Picture
  PUBLIC_DIR = Pathname(ENV.fetch("PUBLIC_DIR")).expand_path
  EXTENSIONS = ENV.fetch("PHOTO_EXT").split(",").freeze

  class << self
    def folders
      @folders ||= Set.new(PUBLIC_DIR.children.
                                      select(&:directory?).
                                      map { |path|
                                        path.basename.to_s
                                      })
    end

    def from_folder(folder)
      return [] unless folders.include?(folder)

      exts = EXTENSIONS.map { |ext| File.join(folder, "*.#{ext}") }
      Dir.chdir(PUBLIC_DIR) do
        Dir[*exts].reject { |pic_path| pic_path =~ /_thumb[.]/ }.
                   map { |pic_path| new(pic_path) }
      end
    end
  end

  attr_reader :path

  def initialize(path)
    @path = Pathname(path)
  end

  def thumb_fname
    dir, file = path.split
    ext = file.extname
    dir.join("#{file.basename(ext)}_thumb#{ext}")
  end
end
