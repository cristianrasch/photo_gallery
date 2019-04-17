require_relative "test_helper"

require "rack/test"

ENV["PICS_DIR"] = "test/fixtures"
require_relative "../app"
require_relative "../helpers/date_helper"

class AppTest < Minitest::Test
  include Rack::Test::Methods
  include DateHelper::InstanceMethods

  def app
    App
  end

  def test_index
    get "/"

    assert_predicate last_response, :ok?
    body = last_response.body
    Picture.folders.each do |folder|
      assert_match folder, body
      date = parse_date(folder)
      assert_match date.year.to_s, body
      assert_match date.strftime(DateHelper::DEF_DT_FMT), body
    end
  end

  def test_show
    folder = Picture.folders.first

    get "/#{folder}"

    assert_predicate last_response, :ok?
    body = last_response.body
    # /fixtures/March_2019/thumb/p1080759_12566175165_o_opt.jpg
    # /fixtures/March_2019/web/p1080759_12566175165_o_opt.jpg
    Dir.chdir("test") do
      Dir["fixtures/#{folder}/*/*.jpg"].each do |jpeg|
        assert_match jpeg, body
      end
    end
  end
end
