class PathRespond

  def initialize
    @count = 0
  end

  def hello
    @count += 1
    "Hello World! (#{@count})"
  end

  def datetime
    "#{Time.now.strftime("%H:%M%p on %A, %B %-m, %Y")}"
  end

  def shutdown(count)
    "Total requests: #{count}"
  end

end
