require "./test/test_helper"
require "./lib/parser"

class ParserTest < Minitest::Test

  def test_it_exists
    parser = Parser.new

    assert_instance_of Parser, parser
  end

  def test_request_exists
    parser = Parser.new

    assert_equal ["GET /datetime HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"],
                      parser.request(["GET /datetime HTTP/1.1",
                                        "Host: localhost:9292",
                                        "Upgrade-Insecure-Requests: 1",
                                        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                                        "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                                        "Accept-Language: en-us",
                                        "Accept-Encoding: gzip, deflate",
                                        "Connection: keep-alive"])
  end

  def test_path_exists
    parser = Parser.new

    assert_equal "/datetime",
    parser.path(["GET /datetime HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])
  end

  def test_verb_exists
    parser = Parser.new

    assert_equal "GET",
    parser.verb(["GET /datetime HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])
  end

  def test_host_exists
    parser = Parser.new

    assert_equal "localhost:9292",
    parser.host(["GET /datetime HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])
  end

  def test_params
    parser = Parser.new

    assert_equal "power",
    parser.params(["GET /word_search?param=power HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])
  end

  def test_params_does_not_accept_wrong_input
    parser = Parser.new

    assert_nil parser.params(["GET /word_search?param= HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])
  end
end
