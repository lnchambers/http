require "socket"
require "pry"
require_relative "parser"
require_relative "path_respond"
require_relative "game"

class Server

  attr_reader :post_data

  def initialize
    @output = ""
    @post_data
    @game
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
      content_length = parser.content_length(request)
      @post_data = listener.read(content_length.to_i)
      @post_data = post_data.split[-2]

      puts "Got this request:"
      count += 1
      puts request.inspect

      if parser.path(request) == "/hello"
        @output = path_respond.hello + respond(parser, request)
      elsif parser.path(request) == "/datetime"
        @output = path_respond.datetime + respond(parser, request)
      elsif parser.path(request) == "/shutdown"
        @output = path_respond.shutdown(count) + respond(parser, request)
        listener.puts path_respond.headers(@output)
        listener.puts @output
        render_view(listener)
        close_server(tcp_server)
      elsif parser.path(request) == "/word_search"
        params = parser.params(request)
        @output = path_respond.word_search(params) + respond(parser, request)
      elsif parser.path(request) == "/start_game" && parser.verb(request) == "POST"
        @game = Game.new
        @output = game_start(listener, request, parser)
      elsif parser.path(request) == "/game" && @game.nil?
        @output = "Please start a game first by going to /start_game"
      elsif parser.path(request) == "/game" && !@game.nil?
      else
        @output = respond(parser, request)
      end
      render_view(listener, path_respond)
    end
  end

  def respond(parser, request)
    puts "Sending response."
    "<pre>" + request.join("\n") + "</pre>"
    "<html><head></head><body><pre>
    Verb: #{parser.verb(request)}
    Path: #{parser.all_params(request)}
    Protocol: #{parser.http(request)}
    Host: #{parser.host(request)}
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

  def render_view(listener, path_respond)
    listener.puts path_respond.headers(@output)
    listener.puts @output
    puts ["Wrote this response:", path_respond.headers(@output), @output].join("\n")
    # listener.close
    puts "\nResponse complete : Exiting."
  end

  def game_start(listener, request, parser)
    if parser.path(request) == "/start_game" && parser.verb(request) == "POST"
      "Good luck!"
    elsif parser.path(request) == "/game" && parser.verb(request) == "POST"
      @game.post()
      @output = game.check_guess
    elsif parser.path(request) == "/game" && parser.verb(request) == "GET"
      @game.get
    elsif check_guess.includes? "Congratulations"
      return check_guess
    else
      "You have to put a number."
    end
  end

  def close_server(tcp_server)
    tcp_server.close
  end


end
