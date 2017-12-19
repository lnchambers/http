class PathRespond

  def initialize
    @hello_count = 0
  end

  def hello
    @hello_count += 1
    "Hello World! (#{@hello_count})"
  end

  def datetime
    "#{Time.now.strftime("%l:%M%p on %A, %B %-m, %Y")}"
  end

  def shutdown(count)
    "Total requests: #{count}"
  end

  def word_search(parameters)
    if parameters.nil?
      "Your word is no good around these parts."
    else
      word_find(parameters)
    end
  end

  def word_find(parameters)
    dictionary = File.read("/usr/share/dict/words").split
    if dictionary.include?(parameters.downcase)
      "#{parameters.capitalize} is known to the Galactic Senate."
    else
      "#{parameters.capitalize} is unknown to the Jedi Council."
    end
  end

  def headers(output)
    ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

end
