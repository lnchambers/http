require "socket"
require_relative "parser"
require_relative "path_respond"

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
    parser = Parser.new
    path_respond = PathRespond.new
    count = 0
    loop do
      puts "Ready for a request"
      listener = tcp_server.accept
      request_lines = []
      while line = listener.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      count += 1
      puts request_lines.inspect

      if parser.path(request_lines) == "/hello"
        path_respond.hello
      elsif parser.path(request_lines) == "/datetime"
        path_respond.datetime
      elsif parser.path(request_lines) == "/shutdown"
        path_respond.shutdown(count)
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

  def headers
    ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end
end
