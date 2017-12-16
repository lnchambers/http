require "pry"

class Hello

  def initialize
    @count = 0
  end

  def hello_world
    @count += 1
    print "<html><head></head><body>Hello world! (#{@count})</body></html>"
  end
end
