#refactor pieces
#check
#commit to git

require_relative 'display.rb'
require_relative 'pieces.rb'
require_relative 'stepping_piece.rb'
require_relative 'sliding_piece.rb'
require 'colorize'

class Board
  attr_accessor :board, :cursor
  include Display
  PIECE_ORDER = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  def self.blank_board
    Board.new(false)
  end

  def initialize(blank = true)
    @board = Array.new(8) { Array.new(8) }
    @cursor = [0,0]
    @killed_pieces = []
    populate_board if blank
  end

  def [](pos)
    x,y = pos
    @board[x][y]
  end

  def []=(pos,value)
    x,y = pos
    @board[x][y] = value
  end

  def populate_board
    @board.each_with_index do | row , row_idx |
      row.each_index do |col_idx|
        if row_idx == 0
          self[[row_idx,col_idx]] = PIECE_ORDER[col_idx].new(self,[row_idx,col_idx],"white")
        elsif row_idx == 1
          self[[row_idx,col_idx]] = Pawn.new(self,[row_idx,col_idx],"white")
        elsif row_idx == 6
          self[[row_idx,col_idx]] = Pawn.new(self,[row_idx,col_idx],"black")
        elsif row_idx == 7
          self[[row_idx,col_idx]] = PIECE_ORDER[col_idx].new(self,[row_idx,col_idx],"black")
        else
          self[[row_idx,col_idx]] = EmptySpace.new([row_idx,col_idx])
        end
      end
    end
  end

  def render
    @board.each_with_index do |row,row_idx|
      row.each_with_index do |cell,col_idx|
        if  [row_idx,col_idx] == @cursor
          print " #{cell.symbol} ".colorize(:background => :yellow)
        elsif self[@cursor].moves.include?([row_idx,col_idx])
          print " #{cell.symbol} ".colorize(:background => :green)
        elsif (row_idx.odd? && col_idx.even?) || (row_idx.even? && col_idx.odd?)
          print " #{cell.symbol} ".colorize(:background => :red)
        else
          print " #{cell.symbol} ".colorize(:background => :blue)
        end
      end
      puts
    end
    p @killed_pieces.join(" ")
  end

  def move!(movement)
    start_pos, end_pos = movement
    if self[start_pos].moves.include?(end_pos)

      unless empty_space?(end_pos)
          @killed_pieces << self[end_pos].symbol
          self[end_pos] = EmptySpace.new(end_pos)
      end
      self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
      self[start_pos].pos, self[end_pos].pos = self[end_pos].pos, self[start_pos].pos

      self[end_pos].moved = true if self[end_pos].is_a?(Pawn)
    else
      puts "Invalid move!" # check this
    end
  end

  def king_position(color)
    @board.each_with_index do |row,row_idx|
      row.each_with_index do |cell,col_idx|
        return [row_idx,col_idx] if cell.is_a?(King) && cell.color == color
      end
    end
  end

  def in_check?(color)
    all_color_moves = []

    @board.each_with_index do |row,row_idx|
      row.each_with_index do |cell,col_idx|
        all_color_moves.concat(cell.moves) if cell.color == other_color(color)
      end
    end
    all_color_moves.include?(king_position(color))

  end


  def other_color(color)
    color = color == "white" ? "black" : "white"
  end

  def deep_dup
    blank_board = Board.blank_board
    @board.each_with_index do |row,row_idx|
      row.each_with_index do |cell,col_idx|
        blank_board[[row_idx,col_idx]] = cell.dupe
      end
    end
    blank_board
  end

  def on_board?(pos)
    pos.all? {|value| value.between?(0,7) }
  end

  def empty_space?(pos)
    self[pos].is_a?(EmptySpace)
  end

  def length
    @board.length
  end
end



# b = Board.new
# b.render
# c = b.deep_dup
# puts "duped"
# c.render
# puts "original"
# b.move!([3,0],[4,1])
# b.render
# puts "duped"
# c.render
