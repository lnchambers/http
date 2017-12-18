require "socket"
require "pry"
require_relative "parser"
require_relative "path_respond"
require_relative "game"

class Server

  def initialize
    @output = ""
  end

  def start
    tcp_server = TCPServer.open(9292)
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
        @output = path_respond.hello + respond(parser, request)
      elsif parser.path(request) == "/datetime"
        @output = path_respond.datetime + respond(parser, request)
      elsif parser.path(request) == "/shutdown"
        @output = path_respond.shutdown(count) + respond(parser, request)
        listener.puts headers
        listener.puts @output
        render_view(listener)
        close_server(tcp_server)
      elsif parser.path(request) == "/word_search"
        params = parser.params(request)
        @output = path_respond.word_search(params) + respond(parser, request)
      elsif parser.path(request) == "/start_game" && parser.verb(request) == "POST"
        game_start(listener, request, parser)
      else
        respond(request, listener, parser)
      end
      render_view(listener)
    end
  end

  def respond(parser, request)
    # puts "Sending response."
    # "<pre>" + request.join("\n") + "</pre>"
    "<html><head></head><body><pre>
    Verb: #{parser.verb(request)}
    Path: #{parser.all_params(request)}
    Protocol: #{parser.http(request)}
    Host: #{parser.host(request)}
    Port: 3000
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

  def game_start(listener, request, parser)
    game = Game.new
    listener
    if parser.path(request) == "/start_game" && parser.verb(request) == "POST"
      "Good luck!"
    elsif parser.path(request) == "/game" && parser.verb(request) == "POST"
      game.post
      @output = game.check_guess
    elsif parser.path(request) == "/game" && parser.verb(request) == "GET"
      game.get
    elsif check_guess.includes? "Congratulations"
      return check_guess
    else
      "You have to put a number."
    end
    game_start
  end

  def close_server(tcp_server)
    tcp_server.close
  end


end
