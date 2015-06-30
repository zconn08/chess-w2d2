require_relative 'player'

module Display

  MOVES = {
    "a" => [0,-1],
    "s" => [1,0],
    "d" => [0,1],
    "w" => [-1,0]
    # "/r" => [0,0]

  }

  def move_cursor(player_input)
    direction = MOVES[player_input]
    dx, dy = direction
    potential_x, potential_y = @cursor[0] + dx, @cursor[1] + dy
    if potential_x.between?(0,7) && potential_y.between?(0,7)
      @cursor = [@cursor[0] + dx, @cursor[1] + dy]
    end
  end



end
