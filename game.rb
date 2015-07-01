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

  def play
    loop do
      take_turn
    end
  end

  def take_turn
    #put statement
    system('clear')
    move_positions = []
    while move_positions.count < 2 do
      @board.render
      @board.debugging_output
      movement = @current_player.get_cursor_movement
      move_positions << @board.cursor if movement == "\r"
      @board.move_cursor(movement)
      system('clear')
    end
    @board.move!(move_positions)
    @board.render
  end

end

game = Game.new(Player.new,Player.new)
game.play
