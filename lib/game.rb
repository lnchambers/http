require_relative "parser"
require_relative "server"

class Game

  attr_reader :guess,
              :guess_count,
              :correct_number

  def initialize
    @guess = 0
    @guess_count = 0
    @correct_number = rand(100)
  end

  def get
    if @guess_count >= 1
      "#{check_guess}, and you've taken #{@guess_count} guesses."
    else
      "You have to make a guess first."
    end
  end

  def post(post_data)
    @guess = post_data
    @guess_count += 1
  end

  def check_guess
    if @guess > @correct_number
      "Your guess is high"
    elsif @guess < @correct_number
      "Your guess is low"
    else
      "Congratulations! The number was #{@correct_number} and it only took you #{@guess_count} tries!"
    end
  end

end
