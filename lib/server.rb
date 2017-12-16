require "socket"
require "uri"
require "pry"

WEB_ROOT = "./lib"

CONTENT_TYPE_MAPPING = {"html" => "text/html",
                        "txt"  => "text/plain",
                        "png"  => "image/png",
                        "jpg"  => "image/jpeg"}

DEFAULT_CONTENT_TYPE = "application/octet-stream"

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

def requested_file(request_line)
  request_uri = request_line[1]
  path        = URI.unescape(URI(request_uri).path)

  clean = []

  parts = path.split("/")

  parts.each do |part|
    next if part.empty? || part == "."
    part == ".." ? clean.pop : clean << part
  end

  File.join(WEB_ROOT, *clean)
end

tcp_server = TCPServer.new(9292)
count = 0

loop do
  puts "Ready for a request"
  listener = tcp_server.accept
  count += 1
  while line = listener.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect

  path = requested_file(request_lines)

  if File.exist?(path) && !File.directory?(path)
    File.open(path, "rb") do file
      listener.print "HTTP/1.1 200 ok\r\n" +
                     "content-type: #{content_type(file)}\r\n" +
                     "content-length: #{file.size}\r\n"

      IO.copy_stream(file, listener)
    end
  else
    response = "File not found"

    listener.print "HTTP/1.1 404 Not Found\r\n" +
                   "content_type: text/plain\r\n" +
                   "content_length: #{response.size}\r\n"

    listener.print message
  end

  puts "Sending response."
  response = "<pre>" + request_lines.join("\n") + "</pre>"
  output = "<html><head></head><body>Hello World! (#{count})</body></html>"
  headers = ["http/1.1 200 ok",
        "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
        "server: ruby",
        "content-type: text/html; charset=iso-8859-1",
        "content-length: #{output.length}\r\n\r\n"].join("\r\n")
        listener.puts headers
        listener.puts output

  puts ["Wrote this response:", headers, output].join("\n")
  listener.close
  puts "\nResponse complete : Exiting."
end
