#stop movements when reach an filled space
#make pieces move

require_relative 'display.rb'
require_relative 'pieces.rb'
require_relative 'stepping_piece.rb'
require_relative 'sliding_piece.rb'
require 'colorize'

class Board
  attr_accessor :board
  include Display
  PIECE_ORDER = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
  def initialize
    @board = Array.new(8) { Array.new(8) { EmptySpace.new } }
    @cursor = [0,0]
    populate_board
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
    @board.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        @board[i][j] = PIECE_ORDER[j].new(self,[i,j],"white") if i == 0
        @board[i][j] = Pawn.new(self,[i,j],"white") if i == 3
        @board[i][j] = Pawn.new(self,[i,j],"black") if i == 4
        @board[i][j] = PIECE_ORDER[j].new(self,[i,j],"black") if i == 7
      end
    end
  end

  def render
    @board.each_with_index do |row,i|
      row.each_with_index do |cell,j|
        if  [i,j] == @cursor
          print " #{cell.symbol} ".colorize(:background => :yellow)
        elsif (i.odd? && j.even?) || (i.even? && j.odd?)
          print " #{cell.symbol} ".colorize(:background => :red)
        else
          print " #{cell.symbol} ".colorize(:background => :blue)
        end
      end
      puts
    end
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


b = Board.new
piece = b[[3, 1]]
p piece.symbol
p piece.moves
