class PathRespond

  def hello(count)
    count += 1
    "Hello World! (#{count})"
  end

  def datetime
    "#{Time.now.strftime("%H:%M%p on %A, %B %-m, %Y")}"
  end

  def shutdown(count)
    "Total requests: #{count}"
  end

end
