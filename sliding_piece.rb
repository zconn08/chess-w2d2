require_relative 'pieces.rb'

class SlidingPiece < Piece
  XY_DIRECTIONS = [[0,-1],[1,0],[0,1],[-1,0]]
  DIAGONAL_DIRECTIONS = [[1,1],[1,-1],[-1,-1],[-1,1]]

  def initialize(board, pos, color)
    super
  end

  def moves(move_directions)
    potential_moves = []
    move_directions.each do |direction|

    potential_moves.concat(add_position(direction))

    end
    potential_moves
  end

  def add_position(direction)
    potential_moves = []
    (@board.length).times do |idx|
      possible_position = [@pos[0] + (direction[0] * idx),@pos[1] + (direction[1] * idx)]
      next if possible_position == @pos
      break unless @board.on_board?(possible_position)

      if @board.empty_space?(possible_position)
        potential_moves << possible_position
        next
      elsif check_enemy_color(possible_position)
        potential_moves << possible_position
      end
      break
    end
    potential_moves
  end
end

class Rook < SlidingPiece
  attr_accessor :symbol

  def initialize(board, pos, color)
    super
    @symbol = color =="white" ? "\u2656" : "\u265C"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    XY_DIRECTIONS
  end
end

class Bishop < SlidingPiece
  attr_accessor :symbol

  def initialize(board, pos, color)
    super
    @symbol = color =="white" ? "\u2657" : "\u265D"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    DIAGONAL_DIRECTIONS
  end
end

class Queen < SlidingPiece
  attr_accessor :symbol

  def initialize(board, pos, color)
    super
    @symbol = color =="white" ? "\u2655" : "\u265B"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    DIAGONAL_DIRECTIONS + XY_DIRECTIONS
  end
end
