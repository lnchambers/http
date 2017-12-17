require "socket"
require "pry"
require "uri"
require_relative "hello"

class Server

  attr_reader :output,
              :hello_count,
              :all_count

  def initialize
    @output = ""
    @hello_count = 0
    @all_count = 0
  end

  def start
    tcp_server = TCPServer.open("localhost", 9292)
    loop do
      puts "Ready for a request"
      listener = tcp_server.accept
      request_lines = []
      while line = listener.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      binding.pry

      puts "Got this request:"
      @all_count += 1
      puts request_lines.inspect

      if path(request_lines) == "/hello"
        hello_count = 0
        hello_count += 1
        output = "<html><head></head><body>Hello world! (#{hello_count})</body></html>"
        listener.print output
      elsif path(request_lines) == "/datetime"
        datetime = "#{Time.now.strftime("%H:%M%p on %A, %B %-m, %Y")}"
        listener.puts datetime
      elsif path(request_lines) == "/shutdown"
        shutdown = "Total requests: #{@all_count}"
        listener.puts shutdown
        return
      else
        respond(request_lines, listener)
      end

      headers = ["http/1.1 200 ok",
                 "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                 "server: ruby",
                 "content-type: text/html; charset=iso-8859-1",
                 "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
      listener.puts headers
      listener.puts @output
      puts ["Wrote this response:", headers, @output].join("\n")
      listener.close
      puts "\nResponse complete : Exiting."
    end
  end

  def respond(request_lines, listener)
    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    @output = "<html><head></head><body><pre>
    Verb: POST
    Path: #{request_lines[0].split(" ")[1]}
    Protocol: HTTP/1.1
    Host: 127.0.0.1
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

  def request(request_lines)
    request_lines
  end

  def path(request_lines)
    request_lines[0].split[1]
  end

  def verb(request_lines)
    request_lines[0].split[0]
  end

  def host(request_lines)
    request_lines[1].split[1]
  end
end
