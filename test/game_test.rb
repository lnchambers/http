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

  def test_game_post_gets_number_and_raises_guess_count
    game = Game.new

    game_post = game.post(["POST /game?param=26 HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])

    assert_equal 26, game.guess
    assert_equal 1, game.guess_count
  end

  def test_game_get_returns_correct_feedback
    game = Game.new

    assert_equal "You have to make a guess first.", game.get

    game.post(["POST /game?param=26 HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])

    assert_equal "#{game.check_guess}, and you've taken #{game.guess_count} guesses.", game.get
  end

  def test_check_guess_checks_guesses
    game = Game.new

    game.post(["POST /game?param=26 HTTP/1.1",
                      "Host: localhost:9292",
                      "Upgrade-Insecure-Requests: 1",
                      "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                      "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
                      "Accept-Language: en-us",
                      "Accept-Encoding: gzip, deflate",
                      "Connection: keep-alive"])
    assert_includes game.check_guess, "Your guess is"
  end
end
