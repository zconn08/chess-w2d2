class Board


  def initialize
    @board = Array.new(8) { Array.new (8) }
  end


private
  def render
    @board.each do |row|
      row.each do |cell|
        print cell
      end
      puts
    end
  end

end
