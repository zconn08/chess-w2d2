require_relative 'board.rb'
require_relative 'player.rb'

class Game

  def initialize(player1,player2)
    @player_one = player1
    @player_two = player2
    @board = Board.new
    players = [@player_one,@player_two]
    @current_player = players.first
  end

  # def play
  #   until over
  #     take_turn
  #   end
  # end

  def take_turn
    #put statement
    @board.render
    loop do
      movement = @current_player.get_cursor_movement
      @board.move_cursor(movement)
      system('clear')
      @board.render
    end
  end

end

game = Game.new(Player.new,Player.new)
game.take_turn
