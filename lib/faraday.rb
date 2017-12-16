require "faraday"
require "pry"

response = Faraday.get("http://127.0.0.1:9292")
