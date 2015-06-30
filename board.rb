require_relative 'display.rb'
require 'colorize'

class Board
  include Display

  def initialize
    @board = Array.new(8) { Array.new(8,"_") }
    @cursor = [0,0]
  end

  def render
    @board.each_with_index do |row,i|
      row.each_with_index do |cell,j|
        if  [i,j] == @cursor
          print cell.colorize(:background => :yellow)
        else
          print cell
        end
      end
      puts
    end
  end



end
