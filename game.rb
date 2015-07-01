require_relative 'board.rb'
require_relative 'player.rb'

class Game
  def initialize(player1,player2)
    @player_one = player1
    @player_two = player2
    @board = Board.new
    players = [@player_one, @player_two]
    @current_player = players.first
  end

  def play
    until game_over?
      take_turn
    end
  end

  def take_turn
    #put statement
    system('clear')
    @board.render
    begin
      move_positions = []
      while move_positions.count < 2 do
        @board.debugging_output
        movement = @current_player.get_cursor_movement
        move_positions << @board.cursor if movement == "\r"
        @board.move_cursor(movement)
        system('clear')
        @board.render
      end
      @board.move!(move_positions)
      @board.render
    rescue MoveError => e
      puts e.message
      retry
    end
  end

  def game_over?
    false
  end
end

game = Game.new(Player.new,Player.new)
game.play
