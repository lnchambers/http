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
    @path_respond = PathRespond.new
    @request = []
    start
    @parser = Parser.new(@request)
    @game
  end

  def start
    loop do
      puts "Ready for a request"
      @listener = @tcp_server.accept
      increment
      while line = @listener.gets and !line.chomp.empty?
        @request << line.chomp
      end
      post_data#(request)

      puts "Got this request:"
      puts @request.inspect
      direct(count)
    end
  end


  def direct(request, count)
    case @parser.path
    when "/" then respond(request)
    when "/hello" then get_hello(request)
    when "/datetime" then get_datetime(request)
    when "/shutdown" then get_shutdown(count)
    when "/word_search" then get_word_search(request)
    when "/start_game" then get_start_game(request)
    when "/game" then get_game_route(request)
    when "/force_error" then get_redirect_500
    else
      get_redirect_404
    end
    render_view
  end

  def respond(request)
    puts "Sending response."
    "<pre>" + request.join("\n") + "</pre>"
    diagnostics
  end

  def diagnostics
    @output = @path_respond.diagnostic(@parser)
  end

  def render_view
    @listener.puts @path_respond.headers(@output, 200)
    @listener.puts @output
    puts ["Wrote this response:".header, @output].join("\n")
    @listener.close
    puts "\nResponse complete : Exiting."
  end

  def game_play(request)
    if @parser.path == "/start_game" && @parser.verb == "POST"
      "Good luck!"
    elsif @parser.path == "/game" && @parser.verb == "POST"
      @game.post(@post_data)
      @output = @game.check_guess
      get_redirect_301
    elsif @parser.path == "/game" && @parser.verb == "GET"
      @output = @game.get
    elsif check_guess.includes? "Congratulations"
      return check_guess
    else
      "You have to put a number."
    end
  end

  def get_redirect_301
    @listener.puts @path_respond.headers(@output, 301)
  end

  def get_redirect_401
    @listener.puts @path_respond.headers(@output, 401)
  end

  def get_redirect_403
    @listener.puts @path_respond.headers(@output, 403)
    @output = "YOU. SHALL. NOT. PASS!
    403
    Forbidden"
    @listener.puts @output
  end

  def get_redirect_404
    @listener.puts @path_respond.headers(@output, 404)
    @output = "They've discovered our secret! Run away!
    404
    Page Not Found"
    @listener.puts @output
  end

  def get_redirect_500
    @listener.puts @path_respond.headers(@output, 500)
    @output = @path_respond.system_error
    close_server
  end

  def get_game_route(request)
    if !@game.nil?
      game_play(request)
    else
      @output = "You have to start a game using /start_game first."
    end
  end

  def close_server
    @tcp_server.close
  end

  def get_shutdown(count)
    @output = @path_respond.shutdown(count) + diagnostics
    render_view
    close_server
  end

  def get_datetime(request)
    @output = @path_respond.datetime + diagnostics
  end

  def get_hello(request)
    @output = @path_respond.hello + diagnostics
  end

  def get_word_search(request)
    params = @parser.params
    @output = @path_respond.word_search(params) + diagnostics
  end

  def get_start_game(request)
    if @parser.verb == "GET"
      @output = "Please put a post request in."
    elsif @game.nil?
      @game = Game.new
      get_redirect_301
      @output = game_play(request) + diagnostics
    else
      get_redirect_403
    end
  end

  def post_data(request)
    content_length = @parser.content_length
    @post_data = @listener.read(content_length.to_i)
    @post_data = post_data.split[-2]
  end

  def increment(count = 0)
    count = count + 1
  end

end
