require_relative "../test_helper"

ENV["PICS_DIR"] = "test/fixtures"
require_relative "../../lib/picture"

class PictureTest < Minitest::Test
  def test_folder_listing
    folders = Picture.folders.to_a

    assert_equal 2, folders.size
    assert_equal "April_2019", folders.first
    assert_equal "March_2019", folders.last
  end

  def test_picture_listing
    folder = Picture.folders.first

    # [#<Picture:0x00005590d04755c0 @path=#<Pathname:/fixtures/April_2019/web/p1080758_12566291413_o_opt.jpg>>]
    pictures = Picture.from_folder(folder)

    assert_equal 1, pictures.size
    pic_path = Dir.chdir("test") { Dir["fixtures/#{folder}/*/*.jpg"].first }
    assert_match pic_path, pictures.first.path.to_s
  end

  def test_thumbnail_filename
    pic = Picture.new("a/#{Picture::WEB_SUBDIR}/b.jpg")

    thumb = pic.thumb_fname.to_s

    refute_match Picture::WEB_SUBDIR, thumb
    assert_match Picture::THUMB_SUBDIR, thumb
  end
end
