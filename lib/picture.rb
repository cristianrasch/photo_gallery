require "pathname"
require "set"
require "date"
require_relative "../config/initializers/dotenv"
require_relative "../helpers/date_helper"

class Picture
  DIR = Pathname(ENV.fetch("PICS_DIR"))
  WEB_SUBDIR = -"web"
  THUMB_SUBDIR = -"thumb"
  EXTENSIONS = ENV.fetch("PHOTO_EXT").split(",").freeze

  class << self
    include DateHelper::InstanceMethods

    def folders(skip_missing_web_thumb_dirs: false)
      Set.new(DIR.expand_path.children.
                              tap do |dirs|
                                dirs.select! { |folder|
                                  folder.directory? &&
                                    [WEB_SUBDIR, THUMB_SUBDIR].all? { |sub_dir|
                                      EXTENSIONS.any? { |ext| !folder.join(sub_dir).
                                                                      glob("*.#{ext}").
                                                                      empty? }
                                    }
                                } unless skip_missing_web_thumb_dirs
                              end.
                              map { |path|
                                path.basename.to_s
                              }.
                              sort { |d1, d2|
                                dt1 = parse_date(d1)
                                dt2 = parse_date(d2)

                                if dt1 && dt2
                                  dt1 <=> dt2
                                elsif dt1.nil?
                                  -1
                                else
                                  1
                                end
                              }.reverse)
    end

    def from_folder(folder)
      return [] unless folders.include?(folder)

      exts = EXTENSIONS.map { |ext| File.join(folder, WEB_SUBDIR, "*.#{ext}") }
      Dir[*exts, base: DIR.expand_path].
        sort_by { |pic_path|
          f = DIR.join(pic_path).expand_path
          [f.mtime, f.basename]
        }.
        map { |pic_path| new("/#{DIR.basename.join(pic_path)}") }
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
