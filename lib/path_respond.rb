class PathRespond

  def initialize
    @hello_count = -1
  end

  def hello
    @hello_count += 1
    "Hello World! (#{@hello_count})"
  end

  def datetime
    "#{Time.now.strftime("%H:%M%p on %A, %B %-m, %Y")}"
  end

  def shutdown(count)
    "Total requests: #{count}"
  end

  def word_search(parameters)
    dictionary = File.read("/usr/share/dict/words").split
    if dictionary.include?(parameters.downcase)
      "#{parameters.capitalize} is known to the Galactic Senate."
    else
      "#{parameters.capitalize} is unknown to the Jedi Council."
    end
  end

end
