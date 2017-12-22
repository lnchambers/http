require "./lib/parser"
require "./lib/server"

class Game

  attr_reader :guess,
              :guess_count,
              :correct_number

  def initialize
    @guess = 0
    @guess_count = 0
    @correct_number = rand(100) + 1
  end

  def get
    "#{check_guess}, and you've taken #{@guess_count} guesses."
  end

  def post(post_data)
    @guess = post_data.to_i
    @guess_count += 1
  end

  def check_guess
    if @guess > @correct_number
      "Your guess is high"
    elsif @guess < @correct_number
      "Your guess is low"
    else
      "Congratulations! The number was #{@correct_number}"
    end
  end

end
