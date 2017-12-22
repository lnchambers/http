require "./lib/response"

module Redirect
  def get_redirect_301
    @listener.puts @response.headers(@output, 301)
  end

  def get_redirect_401
    @listener.puts @response.headers(@output, 401)
  end

  def get_redirect_403
    @listener.puts @response.headers(@output, 403)
    @output = "YOU. SHALL. NOT. PASS!
    403
    Forbidden"
    @listener.puts @output
  end

  def get_redirect_404
    @listener.puts @response.headers(@output, 404)
    @output = "They've discovered our secret! Run away!
    404
    Page Not Found"
    @listener.puts @output
  end

  def get_redirect_500
    @listener.puts @response.headers(@output, 500)
    raise SystemCallError.new("Everything is broken")
  end
end
