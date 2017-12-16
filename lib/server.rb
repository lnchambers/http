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
    loop do
      tcp_server = TCPServer.new(9292)
      puts "Ready for a request"
      listener = tcp_server.accept
      request_lines = []
      while line = listener.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      @all_count += 1
      puts request_lines.inspect
      headers = ["http/1.1 200 ok",
                 "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                 "server: ruby",
                 "content-type: text/html; charset=iso-8859-1",
                 "content-length: #{@output.length}\r\n\r\n"].join("\r\n")

      if request_lines[0].split(" ")[1] == "/hello"
        hello(listener)
      elsif request_lines.inspect[0].split(" ")[1] == "/datetime"
        listener.puts headers[1]
      elsif request_lines.inspect[0].split(" ")[1] == "/shutdown"
        shutdown = "Total requests: #{@all_count}"
        listener.puts shutdown
        return
      else
        respond(request_lines, listener)
      end

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

  def hello(listener)
    @hello_count += 1
    output = "<html><head></head><body>Hello world! (#{@count})</body></html>"
    listener.print output
  end
end
