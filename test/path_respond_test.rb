require "./test/test_helper"
require "./lib/path_respond"

class PathRespondTest < Minitest::Test

  def test_it_exists
    path = PathRespond.new

    assert_instance_of PathRespond, path
  end

  def test_hello
    path = PathRespond.new

    assert_equal "Hello World! (1)", path.hello
    assert_equal "Hello World! (2)", path.hello
  end

  def test_datetime
    path = PathRespond.new

    assert_equal "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}", path.datetime
  end

  def test_shutdown
    path = PathRespond.new

    assert_equal "Total requests: 3", path.shutdown(3)
  end

  def test_word_search_downcases_to_search_and_capitalizes_when_printing
    path = PathRespond.new

    assert_equal "Power is known to the Galactic Senate.", path.word_search("PoWeR")
    assert_equal "Yoda is unknown to the Jedi Council.", path.word_search("yoDA")
  end

  def test_status_codes
    path = PathRespond.new

    assert_equal "301 Moved Permanently", path.status_code(301)
  end

  def test_wrong_status_codes
    path = PathRespond.new

    assert_equal "Bad Header", path.status_code(666)
  end
end
