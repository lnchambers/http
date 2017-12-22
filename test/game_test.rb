require "./test/test_helper"
require "./lib/game"

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

  def test_game_post_gets_number_and_raises_guess_count
    game = Game.new

    game.post("26")

    assert_equal 26, game.guess
    assert_equal 1, game.guess_count
  end

  def test_game_get_returns_correct_feedback
    game = Game.new

    game.post("26")

    assert_equal "#{game.check_guess}, and you've taken #{game.guess_count} guesses.", game.get
  end

  def test_check_guess_checks_guesses
    game = Game.new

    game.post("26")

    assert_includes game.check_guess, "Your guess is"
  end
end
