class Piece
  attr_accessor :pos
  attr_reader :color
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def check_enemy_color(pos)
    @board[pos].color != self.color
  end

  def dupe
    self.class.new(@board, @pos, @color)
  end

end

class EmptySpace
  attr_accessor :pos
  attr_reader :symbol, :color

  def initialize(pos)
    @symbol = " "
    @color = "Empty"
    @pos = pos
  end

  def moves
    []
  end

  def dupe
    self.class.new
  end

end

class Pawn < Piece
  PAWN_DIRECTIONS = [[1,0],[2,0]]
  PAWN_KILL_DIRECTIONS = [[1,1],[1,-1]]
  attr_accessor :symbol, :moved

  def initialize(board, pos, color)
    super
    @moved = false
    @symbol = color =="white" ? "\u2659" : "\u265F"
  end

  def dupe
    new_pawn = self.class.new(@board, @pos, @color)
    new_pawn.moved = @moved
    new_pawn
  end

  def moved?
    @moved
  end

  def moves
    potential_moves = []
    potential_moves.concat(check_non_kill_vectors)
    potential_moves.concat(check_kill_vectors)
  end

  def check_non_kill_vectors
    potential_non_kill_moves = []

    color_change(pawn_vectors).each do |direction|
      possible_position = [@pos[0] + direction[0],@pos[1] + direction[1]]
      next unless @board.on_board?(possible_position) && @board.empty_space?(possible_position)
        potential_non_kill_moves << possible_position
      end

      potential_non_kill_moves
  end

  def check_kill_vectors
    potential_kill_moves = []

    color_change(PAWN_KILL_DIRECTIONS).each do |direction|
      possible_position = [@pos[0] + direction[0],@pos[1] + direction[1]]
      next unless @board.on_board?(possible_position)
      if check_enemy_color(possible_position) && !@board.empty_space?(possible_position)
        potential_kill_moves << possible_position
      end
    end

    potential_kill_moves

  end

  def pawn_vectors
    moved? ? PAWN_DIRECTIONS.take(1) : PAWN_DIRECTIONS
  end

  def color_change(current_moves)
    current_moves.map { |direction| @color == "black" ? [direction[0] * -1, direction[1] * -1] : direction  }
  end
end
