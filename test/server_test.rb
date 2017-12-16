require "minitest/autorun"
require "minitest/pride"
require "pry"
require "../lib/server"

class ServerTest < Minitest::Test

  def test_server_exists
    server = Server.new

    assert_instance_of Server, server
  end

end
