require 'socket'
require 'pry'

class Server

  def initialize
    @tcp_server = TCPServer.new(9292)
    @output = ""
  end

  def start
    loop do
      puts "Ready for a request"
      listener = @tcp_server.accept
      request_lines = []
      while line = listener.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      request = request_lines.inspect
      puts request

      if request_lines.inspect[0].split(" ") == "/hello"
        hello
      else
        request_lines.inspect[0].split(" ") == "/"
        respond(request_lines, listener)
      end

      headers = ["http/1.1 200 ok",
                 "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                 "server: ruby",
                 "content-type: text/html; charset=iso-8859-1",
                 "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
      listener.puts headers
      listener.puts @output
      puts ["Wrote this response:", headers, @output].join("\n")
      listener.close
      puts "\nResponse complete : Exiting."
    end
  end

  def respond(request_lines, listener)
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    @output = "<html><head></head><body><pre>
    Verb: POST
    Path: /
    Protocol: HTTP/1.1
    Host: 127.0.0.1
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

  def hello
    hello = Hello.new
    hello.hello_word
  end
end
