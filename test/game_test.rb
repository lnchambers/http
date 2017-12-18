require "minitest/autorun"
require "minitest/pride"
require "pry"
require_relative "../lib/game.rb"

class GameTest < Minitest::Test

  def test_game_exists
    game = Game.new

    assert_instance_of Game, game
  end

  def test_game_has_correct_attributes
    game = Game.new

    assert_equal 0, game.guess
    assert_equal 0, game.guess_count
  end
end
