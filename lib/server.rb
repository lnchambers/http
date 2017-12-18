require "socket"
require "pry"
require_relative "parser"
require_relative "path_respond"

class Server

  def initialize
    @output = ""
  end

  def start
    tcp_server = TCPServer.open(3000)
    parser = Parser.new
    path_respond = PathRespond.new
    count = 0
    loop do
      puts "Ready for a request"
      listener = tcp_server.accept
      request = []
      while line = listener.gets and !line.chomp.empty?
        request << line.chomp
      end

      puts "Got this request:"
      count += 1
      puts request.inspect

      if parser.path(request) == "/hello"
        @output = path_respond.hello
      elsif parser.path(request) == "/datetime"
        @output = path_respond.datetime
      elsif parser.path(request) == "/shutdown"
        @output = path_respond.shutdown(count)
        listener.puts headers
        listener.puts @output
        render_view(listener)
        render_view(listener)
      elsif parser.path(request) == "/word_search"
        params = parser.params(request)
        @output = path_respond.word_search(params)
      elsif parser.path(request) == "/start_game"
        game.start
      else
        respond(request, listener, parser)
      end
      render_view(listener)
    end
  end

  def respond(request, listener, parser)
    puts "Sending response."
    response = "<pre>" + request.join("\n") + "</pre>"
    @output = "<html><head></head><body><pre>
    Verb: #{parser.verb(request)}
    Path: #{parser.all_params(request)}
    Protocol: HTTP/1.1
    Host: #{parser.host(request)}
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

  def headers
    ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def render_view(listener)
    listener.puts headers
    listener.puts @output
    puts ["Wrote this response:", headers, @output].join("\n")
    listener.close
    puts "\nResponse complete : Exiting."
  end

end
