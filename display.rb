require_relative 'board'
require_relative 'player'
require 'io/console'
require 'colorize'

class Display

  MOVES = {
    "a" => [0,-1],
    "s" => [-1,0],
    "d" => [0,1],
    "w" => [1,0]
    # "/r" => [0,0]

  }

  def initialize(board) # add player later
    @cursor = [0,0]
    @board = board
    @player = Player.new
  end

  def move_cursor
    direction = MOVES[@player.get_cursor_movement]
    dx, dy = direction
    @cursor = [@cursor[0] + dx, @cursor[1] + dy]
  end

  

end
