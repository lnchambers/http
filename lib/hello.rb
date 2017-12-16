require "pry"
require_relative "server"

class Hello

  def initialize
    @count = 0
  end

  def hello_world(listener)
    @count += 1
    output = "<html><head></head><body>Hello world! (#{@count})</body></html>"
    listener.print output
  end
end
