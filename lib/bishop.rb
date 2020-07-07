require 'colorize'
require_relative 'pieces'
class Bishop < Pieces
  attr_reader :green_square_array
  def initialize
    super()
  end

  def bishop_move(array, coord, color_piece)
    @green_square_array = []
    @array = array
    if color_piece == 'black' 
      @opponent_piece = @white_pieces
      @piece = @black_pieces
      @symbol = '♝'
      @opp_color_piece = 'white'
    else
      @opponent_piece = @black_pieces
      @piece = @white_pieces
      @symbol = '♗'
      @opp_color_piece = 'black'
    end
    @row, @column = change_alphabet_to_array(coord)
    downwards_diagonal
    upwards_diagonal
    downwards_anti_diagonal
    upwards_anti_diagonal
    return look_ahead(@green_square_array, @array, @symbol, @opp_color_piece) if @check_for_checkmate == true
    @array
  end
  
  private
  
  def downwards_diagonal
    i = 1
    while @row + i <= 7 && @column + i <= 7
      break if (@piece & @array[@row + i][@column + i].split('')).any?
      if (@opponent_piece & @array[@row + i][@column + i].split('')).any?
        @array[@row + i][@column + i] = @array[@row + i][@column + i].on_green
        @green_square_array << [@row + i, @column + i]
        break
      end
        @array[@row + i][@column + i] = @array[@row + i][@column + i].on_green
        @green_square_array << [@row + i, @column + i]
        i += 1
    end
  end

  def upwards_diagonal
    i = 1
    while @row - i >= 0  && @column - i >= 0
      break if (@piece & @array[@row - i][@column - i].split('')).any?
      if (@opponent_piece & @array[@row - i][@column - i].split('')).any?
        @array[@row - i][@column - i] = @array[@row - i][@column - i].on_green
        @green_square_array << [@row - i, @column - i]
        break
      end
      @array[@row - i][@column - i] = @array[@row - i][@column - i].on_green
      @green_square_array << [@row - i, @column - i]
      i += 1
    end
  end

  def downwards_anti_diagonal
    i = 1
    while @row + i <= 7 && @column - i >= 0
      break if (@piece & @array[@row + i][@column - i].split('')).any?
      if (@opponent_piece & @array[@row + i][@column - i].split('')).any?
        @array[@row + i][@column - i] = @array[@row + i][@column - i].on_green
        @green_square_array << [@row + i, @column - i]
        break
      end
        @array[@row + i][@column - i] = @array[@row + i][@column - i].on_green
        @green_square_array << [@row + i, @column - i]
        i += 1
    end
  end

  def upwards_anti_diagonal
    i = 1
    while @row - i >= 0 && @column + i <= 7
      break if (@piece & @array[@row - i][@column + i].split('')).any?
      if (@opponent_piece & @array[@row - i][@column + i].split('')).any?
        @array[@row - i][@column + i] = @array[@row - i][@column + i].on_green
        @green_square_array << [@row - i, @column + i]
        break
      end
        @array[@row - i][@column + i] = @array[@row - i][@column + i].on_green
        @green_square_array << [@row - i, @column + i]
        i += 1
    end
  end
end
