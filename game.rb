require_relative 'board.rb'
require_relative 'player.rb'

class Game
  def initialize(player1,player2)
    @player_one = player1
    @player_two = player2
    @player_one.color = "white"
    @player_two.color = "black"
    @board = Board.new
    @players = [@player_one, @player_two]
    @current_player = @players.first
  end

  def play
    until game_over?
      take_turn
      rotate_players
    end
    puts "Game over! #{@players.last.name} won!"
  end

  def rotate_players
    @players.rotate!
    @current_player = @players.first
  end

  def take_turn
    render_with_instructions

    begin
      move_positions = []
      while move_positions.count < 2 do

        @board.debugging_output

        movement = @current_player.get_cursor_movement

        if movement == "\r" &&
          ((@board.occupied? && selected_right_color) ||
            (move_positions.length == 1))

          move_positions << @board.cursor
        end

        @board.move_cursor(movement)
        render_with_instructions
      end

      @board.move!(move_positions)

    rescue MoveError => e

      puts e.message
      retry
    end
  end

  def selected_right_color
    @board.all_color_positions(@current_player.color).include?(@board.cursor)
  end

  def render_with_instructions
    system('clear')
    @board.render
    puts "Please make a move #{@current_player.name}. Your color is #{@current_player.color}"
  end

  def game_over?
    @board.game_over?
  end
end

game = Game.new(Player.new("Sam"),Player.new("Zach"))
game.play
