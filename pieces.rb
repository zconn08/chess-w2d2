class Piece
  attr_reader :color
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def check_enemy_color(pos)
    @board[pos].color != self.color
  end

end

class EmptySpace
  attr_reader :symbol, :color

  def initialize
    @symbol = " "
    @color = "Empty"
  end

  def moves

  end

end

class Pawn < Piece
  PAWN_VECTORS = [[1,0],[2,0]]
  PAWN_KILL_VECTORS = [[1,1],[1,-1]]
  attr_accessor :symbol

  def initialize(board, pos, color)
    super
    @moved = false
    @symbol = color =="white" ? "\u2659" : "\u265F"
  end

  def moved?
    @moved
  end

  def moves
    potential_moves = []

    color_change(move_directions).each do |vector|
      possible_position = [@pos[0] + vector[0],@pos[1] + vector[1]]
      next unless @board.on_board?(possible_position) && @board.empty_space?(possible_position)
        potential_moves << possible_position
      end

    color_change(PAWN_KILL_VECTORS).each do |vector|
      possible_position = [@pos[0] + vector[0],@pos[1] + vector[1]]
      if check_enemy_color(possible_position)
        potential_moves << possible_position
      end
    end
    
    potential_moves
  end

  def move_directions
    moved? ? PAWN_VECTORS.take(1) : PAWN_VECTORS
  end

  def color_change(available_moves)
    available_moves.map { |vector| @color == "black" ? [vector[0] * -1, vector[1] * -1] : vector  }
  end
end
