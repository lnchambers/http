require "minitest/autorun"
require "minitest/pride"
require "pry"
require_relative "../lib/server"

class ServerTest < Minitest::Test

  def test_server_exists
    server = Server.new

    assert_instance_of Server, server
  end

  def test_server_instantiates_desired_attributes
    server = Server.new

    assert_instance_of Server, server
    assert server.output.empty?
    assert_equal 0, server.hello_count
  end

end
