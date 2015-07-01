#refactor pieces
#validate actual movements
#fix pawn moved
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
    @board.each_with_index do | row_array , row |
      row_array.each_index do |col|
        if row == 0
          self[[row,col]] = PIECE_ORDER[col].new(self,[row,col],"white")
        elsif row == 1
          self[[row,col]] = Pawn.new(self,[row,col],"white")
        elsif row == 6
          self[[row,col]] = Pawn.new(self,[row,col],"black")
        elsif row == 7
          self[[row,col]] = PIECE_ORDER[col].new(self,[row,col],"black")
        else
          self[[row,col]] = EmptySpace.new([row,col])
        end
      end
    end
  end

  def render
    @board.each_with_index do |row,i|
      row.each_with_index do |cell,j|
        if  [i,j] == @cursor
          print " #{cell.symbol} ".colorize(:background => :yellow)
        elsif self[@cursor].moves.include?([i,j])
          print " #{cell.symbol} ".colorize(:background => :green)
        elsif (i.odd? && j.even?) || (i.even? && j.odd?)
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
    unless empty_space?(end_pos)
        @killed_pieces << self[end_pos].symbol
        self[end_pos] = EmptySpace.new
    end
    self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
    self[start_pos].pos, self[end_pos].pos = self[end_pos].pos, self[start_pos].pos
  end

  def deep_dup
    blank_board = Board.blank_board
    @board.each_with_index do |row,i|
      row.each_with_index do |cell,j|
        blank_board[[i,j]] = cell.dupe
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
