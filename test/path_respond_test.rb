require "minitest/autorun"
require "minitest/pride"
require "pry"
require_relative "../lib/path_respond"

class PathRespondTest < Minitest::Test

  def test_it_exists
    path_respond = PathRespond.new

    assert_instance_of PathRespond, path_respond
  end

  def test_hello
    path_respond = PathRespond.new

    assert_equal "Hello World! (1)", path_respond.hello(0)
    assert_equal "Hello World! (2)", path_respond.hello(1)
  end

  def test_datetime
    path_respond = PathRespond.new

    assert_equal "#{Time.now.strftime("%H:%M%p on %A, %B %-m, %Y")}", path_respond.datetime
  end

  def test_shutdown
    path_respond = PathRespond.new

    assert_equal "Total requests: 3", path_respond.shutdown(3)
  end

end
