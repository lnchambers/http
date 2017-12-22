require "./test/test_helper"
require "./lib/response"

class ResponseTest < Minitest::Test

  def test_it_exists
    response = Response.new

    assert_instance_of Response, response
  end

  def test_hello
    response = Response.new

    assert_equal "Hello World! (1)", response.hello
    assert_equal "Hello World! (2)", response.hello
  end

  def test_datetime
    response = Response.new

    assert_equal "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}", response.datetime
  end

  def test_shutdown
    response = Response.new

    assert_equal "Total requests: 3", response.shutdown(3)
  end

  def test_word_search_downcases_to_search_and_capitalizes_when_printing
    response = Response.new

    assert_equal "Power is known to the Galactic Senate.", response.word_search("PoWeR")
    assert_equal "Yoda is unknown to the Jedi Council.", response.word_search("yoDA")
  end
end
