require "socket"
require "pry"
require "./lib/parser"
require "./lib/response"
require "./lib/game"

class Server

  attr_reader :post_data

  def initialize
    @output = ""
    @tcp_server = TCPServer.open(9292)
    @response = Response.new
    @post_data
    @request = []
    @game
  end

  def start
    count = 0
    loop do
      puts "Ready for a request"
      @listener = @tcp_server.accept
      count += 1
      @request = []
      while line = @listener.gets and !line.chomp.empty?
        @request << line.chomp
      end
      @parser = Parser.new(@request)
      content_length = @parser.content_length
      @post_data = @listener.read(content_length.to_i)
      @post_data = @post_data.split[-2]

      puts "Got this @request:"
      puts @request.inspect
      direct(count)
    end
  end


  def direct(count)
    case @parser.path
    when "/" then respond
    when "/hello" then get_hello
    when "/datetime" then get_datetime
    when "/shutdown" then get_shutdown(count)
    when "/word_search" then get_word_search
    when "/start_game" then get_start_game
    when "/game" then get_game_route
    when "/force_error" then get_redirect_500
    else
      get_redirect_404
    end
    render_view
  end

  def respond
    puts "Sending response."
    "<pre>" + @request.join("\n") + "</pre>"
    diagnostics
  end

  def diagnostics
    @output = @response.diagnostic(@parser)
  end

  def render_view
    @listener.puts @response.header_200(@output)
    @listener.puts @output
    puts ["Wrote this response:", @response.header_200(@output), @output].join("\n")
    @listener.close
    puts "\nResponse complete : Exiting."
  end

  def game_play
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

  def get_game_route
    if !@game.nil?
      game_play
    else
      @output = "You have to start a game using /start_game first."
    end
  end

  def close_server
    @tcp_server.close
  end

  def get_shutdown(count)
    @output = @response.shutdown(count) + diagnostics
    render_view
    close_server
  end

  def get_datetime
    @output = @response.datetime + diagnostics
  end

  def get_hello
    @output = @response.hello + diagnostics
  end

  def get_word_search
    params = @parser.params
    @output = @response.word_search(params) + diagnostics
  end

  def get_start_game
    if @parser.verb == "GET"
      @output = "Please put a post request in."
    elsif @game.nil?
      @game = Game.new
      get_redirect_301
      @output = game_play + diagnostics
    else
      get_redirect_403
    end
  end

  def post_data
    @parser = Parser.new(@request)
    content_length = @parser.content_length
    @post_data = @listener.read(content_length.to_i)
    @post_data = post_data.split[-2]
  end

  def get_redirect_301
    @listener.puts @response.header_301(@output)
  end

  def get_redirect_401
    @listener.puts @response.header_401(@output)
  end

  def get_redirect_403
    @listener.puts @response.header_403(@output)
    @output = "YOU. SHALL. NOT. PASS!
    403
    Forbidden"
    @listener.puts @output
  end

  def get_redirect_404
    @listener.puts @response.header_404(@output)
    @output = "They've discovered our secret! Run away!
    404
    Page Not Found"
    @listener.puts @output
  end

  def get_redirect_500
    @listener.puts @response.header_500(@output)
    raise SystemCallError.new("Everything is broken")
  end

end
