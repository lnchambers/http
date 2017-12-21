require "socket"
require "pry"
require_relative "parser"
require_relative "path_respond"
require_relative "game"

class Server

  attr_reader :post_data

  def initialize
    @output = ""
    @tcp_server = TCPServer.open(9292)
    @post_data
    @game
  end

  def start
    path_respond = PathRespond.new
    count = 0
    loop do
      puts "Ready for a request"
      listener = @tcp_server.accept
      request = []
      while line = listener.gets and !line.chomp.empty?
        request << line.chomp
      end
      parser = Parser.new(request)
      content_length = parser.content_length
      @post_data = listener.read(content_length.to_i)
      @post_data = post_data.split[-2]

      puts "Got this request:"
      count += 1
      puts request.inspect
      direct(listener, request, parser, path_respond, count)
    end
  end


  def direct(listener, request, parser, path_respond, count)
    case parser.path
      when "/" then respond(parser, request)
      when "/hello" then get_hello(path_respond, parser, request)
      when "/datetime" then get_datetime(path_respond, parser, request)
      when "/shutdown" then get_shutdown(listener, path_respond, parser, count)
      when "/word_search" then get_word_search(path_respond, parser, request)
      when "/start_game" then get_start_game(listener, request, parser, path_respond)
      when "/game" then get_game_route(listener, request, parser, path_respond)
      when "/force_error" then get_error(listener, path_respond)
      else
        get_redirect_404(listener, path_respond)
    end
    render_view(listener, path_respond, parser)
  end

  def respond(parser, request)
    puts "Sending response."
    "<pre>" + request.join("\n") + "</pre>"
    diagnostics(parser)
  end

  def diagnostics(parser)
    @output = "<html><head></head><body><pre>
    Verb: #{parser.verb}
    Path: #{parser.all_params}
    Protocol: #{parser.http}
    Host: #{parser.host}
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

  def render_view(listener, path_respond, parser)
    listener.puts path_respond.header_200(@output)
    listener.puts @output
    puts ["Wrote this response:", path_respond.header_200(@output), @output].join("\n")
    listener.close
    puts "\nResponse complete : Exiting."
  end

  def game_play(listener, request, parser, path_respond)
    if parser.path == "/start_game" && parser.verb == "POST"
      "Good luck!"
    elsif parser.path == "/game" && parser.verb == "POST"
      @game.post(@post_data)
      @output = @game.check_guess
      get_redirect_301(listener, path_respond)
    elsif parser.path == "/game" && parser.verb == "GET"
      @output = @game.get
    elsif check_guess.includes? "Congratulations"
      return check_guess
    else
      "You have to put a number."
    end
  end

  def get_redirect_301(listener, path_respond)
    listener.puts path_respond.header_301(@output)
  end

  def get_redirect_401(listener, path_respond)
    listener.puts path_respond.header_401(@output)
  end

  def get_redirect_403(listener, path_respond)
    listener.puts path_respond.header_403(@output)
  end

  def get_redirect_404(listener, path_respond)
    listener.puts path_respond.header_404(@output)
    @output = "They've discovered our secret! Run away!
    \r\n\r\n404\r\nPage Not Found"
  end

  def get_redirect_500(listener, path_respond)
    @output = raise SystemError
    listener.puts path_respond.header_500(@output)
    close_server
  end

  def get_game_route(listener, request, parser, path_respond)
    if !@game.nil?
      game_play(listener, request, parser, path_respond)
    else
      @output = "You have to start a game using /start_game first."
    end
  end

  def close_server
    @tcp_server.close
  end

  def get_shutdown(listener, path_respond, parser, count)
    @output = path_respond.shutdown(count) + diagnostics(parser)
    render_view(listener, path_respond, parser)
    close_server
  end

  def get_datetime(path_respond, parser, request)
    @output = path_respond.datetime + diagnostics(parser)
  end

  def get_hello(path_respond, parser, request)
    @output = path_respond.hello + diagnostics(parser)
  end

  def get_word_search(path_respond, parser, request)
    params = parser.params
    @output = path_respond.word_search(params) + diagnostics(parser)
  end

  def get_start_game(listener, request, parser, path_respond)
    if parser.verb == "GET"
      @output = "Please put a post request in."
    else
      @game = Game.new
      @output = game_play(listener, request, parser, path_respond) + diagnostics(parser)
    end
  end


end
