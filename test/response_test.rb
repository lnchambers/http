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

  def test_word_search_does_not_accept_nil_input
    response = Response.new

    assert_equal "Your word is no good around these parts.", response.word_search(nil)
  end

  def test_200_header
    response = Response.new

    response.header_200("333")

    expectation ="http/1.1 200 ok\r
      date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r
      server: ruby\r
      content-type: text/html; charset=iso-8859-1\r
      content-length: 3\r
      \r
      "

    assert_equal expectation.split, response.headers.split
  end

  def test_301_header
    response = Response.new

    response.header_301("333")

    expectation ="http/1.1 301 Moved Permanently\r
      Location: http://127.0.0.1:9292/game\r
      date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r
      server: ruby\r
      content-type: text/html; charset=iso-8859-1\r
      content-length: 3\r
      \r
      "

    assert_equal expectation.split, response.headers.split
  end

  def test_401_header
    response = Response.new

    response.header_401("333")

    expectation ="http/1.1 401 Unauthorized\r
      date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r
      server: ruby\r
      content-type: text/html; charset=iso-8859-1\r
      content-length: 3\r
      \r
      "

    assert_equal expectation.split, response.headers.split
  end

  def test_403_header
    response = Response.new

    response.header_403("333")

    expectation ="http/1.1 403 Forbidden\r
      date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r
      server: ruby\r
      content-type: text/html; charset=iso-8859-1\r
      content-length: 3\r
      \r
      "

    assert_equal expectation.split, response.headers.split
  end

  def test_404_header
    response = Response.new

    response.header_404("333")

    expectation ="http/1.1 404 Not Found\r
      date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r
      server: ruby\r
      content-type: text/html; charset=iso-8859-1\r
      content-length: 3\r
      \r
      "

    assert_equal expectation.split, response.headers.split
  end

  def test_500_header
    response = Response.new

    response.header_500("333")

    expectation ="http/1.1 500 Internal Server Error\r
      date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r
      server: ruby\r
      content-type: text/html; charset=iso-8859-1\r
      content-length: 3\r
      \r
      "

    assert_equal expectation.split, response.headers.split
  end

end
