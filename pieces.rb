class Piece
  attr_accessor :pos
  attr_reader :color

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
  end

  def check_enemy_color(pos)
    @board[pos].color != self.color && !(@board[pos].is_a?(EmptySpace))
  end

  def dupe(board)
    self.class.new(board, @pos.dup, @color)
  end

  def can_move?(pos)
    return false unless @board.on_board?(pos)
    @board.empty_space?(pos) || check_enemy_color(pos)
  end

  def move_into_check?(end_pos)
    duped_board = @board.deep_dup
    duped_board.move([@pos,end_pos])
    duped_board.in_check?(@color)
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
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

  def valid_moves
    []
  end

  def dupe(board)
    self.class.new(pos.dup)
  end
end

class Pawn < Piece
  PAWN_DIRECTIONS = [[1, 0], [2, 0]]
  PAWN_KILL_DIRECTIONS = [[1, 1], [1, -1]]

  attr_accessor :symbol, :moved

  def initialize(board, pos, color, moved = false)
    super(board, pos, color)
    @moved = moved
    @symbol = color =="white" ? "\u2659" : "\u265F"
  end

  def dupe(board)
    self.class.new(board, @pos.dup, @color, @moved)
  end

  def moved?
    @moved
  end

  def moves
    non_kill_moves + kill_moves
  end

  def non_kill_moves
    potential_non_kill_moves = []

    color_change(pawn_vectors).each do |direction|
      possible_position = [@pos[0] + direction[0],@pos[1] + direction[1]]
      next unless @board.on_board?(possible_position) && @board.empty_space?(possible_position)
      potential_non_kill_moves << possible_position
    end

    potential_non_kill_moves
  end

  def kill_moves
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
