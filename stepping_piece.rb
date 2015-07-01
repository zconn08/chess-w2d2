require_relative 'pieces.rb'

class SteppingPiece < Piece
  KING_DIRECTIONS = [[0,-1],[1,0],[0,1],[-1,0],[1,1],[1,-1],[-1,-1],[-1,1]]
  KNIGHT_DIRECTIONS = [[-2,-1],[-2,1],[-1,-2],[-1,2],[1,-2],[1,2],[2,-1],[2,1]]

  def initialize(board, pos, color)
    super
  end

  def moves(move_directions)
    potential_moves = []
    move_directions.each do |direction|
      possible_position = [@pos[0] + direction[0], @pos[1] + direction[1]]
      next unless @board.on_board?(possible_position) && (@board.empty_space?(possible_position) || check_enemy_color(possible_position))
      potential_moves << possible_position
    end
    potential_moves
  end
end

class Knight < SteppingPiece
  attr_accessor :symbol

  def initialize(board, pos, color)
    super
    @symbol = color =="white" ? "\u2658" : "\u265E"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    KNIGHT_DIRECTIONS
  end
end

class King < SteppingPiece
  attr_accessor :symbol

  def initialize(board, pos, color)
    super
    @symbol = color =="white" ? "\u2654" : "\u265A"
  end

  def moves
    super(move_directions)
  end

  def move_directions
    KING_DIRECTIONS
  end
end
