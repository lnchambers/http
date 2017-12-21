require "./test/test_helper"
require "./lib/parser"

class ParserTest < Minitest::Test

  def test_it_exists
    parser = Parser.new(["GET /word_search?param= HTTP/1.1",
      "Host: localhost:9292",
       "Upgrade-Insecure-Requests: 1",
        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
          "Accept-Language: en-us",
           "Accept-Encoding: gzip, deflate",
            "Connection: keep-alive"])

    assert_instance_of Parser, parser
  end

  def test_path_exists
    parser = Parser.new(["GET /datetime HTTP/1.1",
      "Host: localhost:9292",
       "Upgrade-Insecure-Requests: 1",
        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
          "Accept-Language: en-us",
           "Accept-Encoding: gzip, deflate",
            "Connection: keep-alive"])

    assert_equal "/datetime", parser.path
  end

  def test_verb_exists
    parser = Parser.new(["GET /word_search?param= HTTP/1.1",
      "Host: localhost:9292",
       "Upgrade-Insecure-Requests: 1",
        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
          "Accept-Language: en-us",
           "Accept-Encoding: gzip, deflate",
            "Connection: keep-alive"])

    assert_equal "GET", parser.verb
  end

  def test_host_exists
    parser = Parser.new(["GET /word_search?param= HTTP/1.1",
      "Host: localhost:9292",
       "Upgrade-Insecure-Requests: 1",
        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
          "Accept-Language: en-us",
           "Accept-Encoding: gzip, deflate",
            "Connection: keep-alive"])

    assert_equal "localhost:9292", parser.host
  end

  def test_params
    parser = Parser.new(["GET /word_search?param=power HTTP/1.1",
      "Host: localhost:9292",
       "Upgrade-Insecure-Requests: 1",
        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
          "Accept-Language: en-us",
           "Accept-Encoding: gzip, deflate",
            "Connection: keep-alive"])

    assert_equal "power", parser.params
  end

  def test_params_does_not_accept_wrong_input
    parser = Parser.new(["GET /word_search?param= HTTP/1.1",
      "Host: localhost:9292",
       "Upgrade-Insecure-Requests: 1",
        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
          "Accept-Language: en-us",
           "Accept-Encoding: gzip, deflate",
            "Connection: keep-alive"])

    assert_nil parser.params
  end

  def test_content_length_returns_correct_length
    parser = Parser.new([
      "POST / HTTP/1.1",
      "Host: 127.0.0.1:9292",
      "Connection: keep-alive",
      "Content-Length: 142",
      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36",
      "Cache-Control: no-cache",
      "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
      "Postman-Token: cddb8d3e-c774-7fe2-0a60-3e99a1a6b5fb",
      "Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryJTTfjsK5SvSGCAZo",
      "Accept: */*",
      "Accept-Encoding: gzip, deflate, br",
      "Accept-Language:en-US,en;q=0.9"
    ])

    assert_equal "142", parser.content_length
  end

  def test_http_returns_http_version
    parser = Parser.new(["POST / HTTP/1.1",
      "Host: 127.0.0.1:9292",
       "Connection: keep-alive",
        "Content-Length: 142",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36",
          "Cache-Control: no-cache",
           "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
            "Postman-Token: cddb8d3e-c774-7fe2-0a60-3e99a1a6b5fb",
             "Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryJTTfjsK5SvSGCAZo",
              "Accept: */*",
               "Accept-Encoding: gzip, deflate, br",
                "Accept-Language:en-US,en;q=0.9"])

    assert_equal "HTTP/1.1", parser.http
  end

  def test_all_params_returns_all_parameters
    parser = Parser.new(["POST /word_search?param=word HTTP/1.1",
      "Host: 127.0.0.1:9292",
       "Connection: keep-alive",
        "Content-Length: 142",
         "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.108 Safari/537.36",
          "Cache-Control: no-cache",
           "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
            "Postman-Token: cddb8d3e-c774-7fe2-0a60-3e99a1a6b5fb",
             "Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryJTTfjsK5SvSGCAZo",
              "Accept: */*",
               "Accept-Encoding: gzip, deflate, br",
                "Accept-Language:en-US,en;q=0.9"])

    assert_equal "/word_search?param=word", parser.all_params
  end
end
