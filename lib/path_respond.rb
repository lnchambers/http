class PathRespond

  attr_reader :headers

  def initialize
    @hello_count = 0
    @headers = []
  end

  def hello
    @hello_count += 1
    "Hello World! (#{@hello_count})"
  end

  def datetime
    "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}"
  end

  def shutdown(count)
    "Total requests: #{count}"
  end

  def word_search(parameters)
    if parameters.nil?
      "Your word is no good around these parts."
    else
      word_find(parameters)
    end
  end

  def word_find(parameters)
    dictionary = File.read("/usr/share/dict/words").split
    if dictionary.include?(parameters.downcase)
      "#{parameters.capitalize} is known to the Galactic Senate."
    else
      "#{parameters.capitalize} is unknown to the Jedi Council."
    end
  end

  def header_200(output)
    @headers = ["http/1.1 200 ok",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def header_301(output)
    @headers = ["http/1.1 301 Moved Permanently",
     "Location: http://127.0.0.1:9292/game",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def header_401(output)
    @headers = ["http/1.1 401 Unauthorized",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def header_403(output)
    @headers = ["http/1.1 403 Forbidden",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def header_404(output)
    @headers = ["http/1.1 404 Not Found",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def header_500(output)
    @headers = ["http/1.1 500 Internal Server Error",
     "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
     "server: ruby",
     "content-type: text/html; charset=iso-8859-1",
     "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def system_error
    "/Users/lukechambers/turing/1module/projects/http/lib/server.rb:23:in `accept': closed stream (IOError)
    from /Users/lukechambers/turing/1module/projects/http/lib/server.rb:23:in `block in start'
    from /Users/lukechambers/turing/1module/projects/http/lib/server.rb:21:in `loop'
    from /Users/lukechambers/turing/1module/projects/http/lib/server.rb:21:in `start'
    from start_server.rb:3:in `<main>'"
  end

  def diagnostic(parser)
    "<html><head></head><body><pre>
    Verb: #{parser.verb}
    Path: #{parser.all_params}
    Protocol: #{parser.http}
    Host: #{parser.host}
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

end
