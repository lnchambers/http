require "./test/test_helper"
require "./lib/server"

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

     assert_equal expected.split(" "), response.body.split(" ")
  end

  def test_request_returns_an_appropiate_array
    response = Faraday.get "http://127.0.0.1:9292"

    assert_instance_of String, response.body
  end

  def test_increment_counter
    response = Faraday.get "http://127.0.0.1:9292"

    assert_equal 1, server.count

    response
    response
    response
    response

    assert_equal 5, server.count
  end

  def test_post_data
    skip
    response = Faraday.post "http://127.0.0.1:9292"

    assert_equal "50", server.post_data
  end

  def test_direction
    skip
    response = Faraday.get "http://127.0.0.1:9292/hello"

    assert_equal "Hello World! (1)", server.output

    response = Faraday.get "http://127.0.0.1:9292/datetime"

    assert_equal "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}", server.output
  end

  def test_render_view
    skip
    response = Faraday.get "http://127.0.0.1:9292"

    #request

    #test_request
  end

  def test_diagnostics_parser
    skip
    response = Faraday.get "http://127.0.0.1:9292"

    #test
  end

end
