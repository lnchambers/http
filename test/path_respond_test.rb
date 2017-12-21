require "./test/test_helper"
require "./lib/path_respond"

class PathRespondTest < Minitest::Test

  def test_it_exists
    path_respond = PathRespond.new

    assert_instance_of PathRespond, path_respond
  end

  def test_hello
    path_respond = PathRespond.new

    assert_equal "Hello World! (1)", path_respond.hello
    assert_equal "Hello World! (2)", path_respond.hello
  end

  def test_datetime
    path_respond = PathRespond.new

    assert_equal "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}", path_respond.datetime
  end

  def test_shutdown
    path_respond = PathRespond.new

    assert_equal "Total requests: 3", path_respond.shutdown(3)
  end

  def test_word_search_downcases_to_search_and_capitalizes_when_printing
    path_respond = PathRespond.new

    assert_equal "Power is known to the Galactic Senate.", path_respond.word_search("PoWeR")
    assert_equal "Yoda is unknown to the Jedi Council.", path_respond.word_search("yoDA")
  end

end
