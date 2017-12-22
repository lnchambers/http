require "./test/test_helper"

class ServerTest < Minitest::Test

  def test_server_starts
    response = Faraday.get "http://127.0.0.1:9292"

    expected = "<html><head></head><body><pre>
      Verb: GET
      Path: /
      Protocol: HTTP/1.1
      Host: Faraday
      Port: 9292
      Origin: 127.0.0.1
      Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
      </pre></body></html>"

     assert_equal expected.split, response.body.split
  end

  def test_request_returns_an_appropiate_class
    response = Faraday.get "http://127.0.0.1:9292"

    assert_instance_of String, response.body
  end

  def test_hello_path_works
    response = Faraday.get "http://127.0.0.1:9292/hello"

    expected = "Hello World! (1)<html><head></head><body><pre>
       Verb: GET
       Path: /hello
       Protocol: HTTP/1.1
       Host: Faraday
       Port: 9292
       Origin: 127.0.0.1
       Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
       </pre></body></html>"

    assert_equal expected.split, response.body.split
  end

  def test_datetime_path_works
    response = Faraday.post "http://127.0.0.1:9292/datetime"

    expected = "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}<html><head></head><body><pre>
      Verb: POST
      Path: /datetime
      Protocol: HTTP/1.1
      Host: Faraday
      Port: 9292
      Origin: 127.0.0.1
      Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
      </pre></body></html>"

    assert_equal expected.split, response.body.split
  end

  def test_word_search_path_works
    response = Faraday.get "http://127.0.0.1:9292/word_search?param=work"

    expected = "Work is known to the Galactic Senate.<html><head></head><body><pre>
      Verb: GET
      Path: /word_search?param=work
      Protocol: HTTP/1.1
      Host: Faraday
      Port: 9292
      Origin: 127.0.0.1
      Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
      </pre></body></html>"

    assert_equal expected.split, response.body.split
  end

  def test_game_when_game_is_nil_and_not_nil
    response = Faraday.get "http://127.0.0.1:9292/game"

    expected = "You have to start a game using /start_game first."

    assert_equal expected, response.body

    response = Faraday.post "http://127.0.0.1:9292/start_game"
    response = Faraday.get "http://127.0.0.1:9292/game"

    expected = "Your guess is low, and you've taken 0 guesses."

    assert_equal expected, response.body
  end

end
