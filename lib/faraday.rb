require "faraday"
require "pry"

response = Faraday.get("http://localhost:9292/datetime")

binding.pry
