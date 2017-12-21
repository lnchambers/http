require "./test/test_helper"
require "./lib/server"

class ServerTest < Minitest::Test

  def test_server_exists
    skip
    server = Server.new

    assert_instance_of Server, server
    server.close_server
  end

  def test_server_starts
    skip
    server = Server.new

    assert_equal "Ready for a request", server.start
    server.close_server
  end

  def test_request_returns_an_appropiate_array
    skip
    server = Server.new

    assert_instance_of Array, server.request
    server.close_server
  end

  def test_increment_counter
    skip
    server = Server.new

    assert_equal 0, server.count

    #request

    assert_equal 1, server.count

    #request
    #request
    #request
    #request

    assert_equal 5, server.count
    server.close_server
  end

  def test_post_data
    skip
    server = Server.new

    #request

    assert_equal "50", server.post_data
    server.close_server
  end

  def test_direction
    skip
    server = Server.new

    #request to hello

    assert_equal "Hello World! (1)", server.output

    #request to datetime

    assert_equal "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}", server.output
    server.close_server
  end

  def test_render_view
    skip
    server = Server.new

    #request

    #test_request
  end

  def test_diagnostics_parser
    skip
    server = Server.new

    #request

    assert_equal "<html><head></head><body><pre>
    Verb: #{parser.verb}
    Path: #{parser.all_params}
    Protocol: #{parser.http}
    Host: #{parser.host}
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>", server.output
  end

end
