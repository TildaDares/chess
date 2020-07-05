require 'colorize'
class Bishop
  attr_reader :green_square_array
  def bishop_move(array, row, column, piece, opponent_piece)
    @green_square_array = []
    array = downwards_diagonal(array, row, column, piece, opponent_piece)
    array = upwards_diagonal(array, row, column, piece, opponent_piece)
    array = downwards_anti_diagonal(array, row, column, piece, opponent_piece)
    array = upwards_anti_diagonal(array, row, column, piece, opponent_piece)
    array
  end
  
  def downwards_diagonal(array, row, column, piece, opponent_piece)
    i = 1
    while row + i <= 7 && column + i <= 7
      break if (piece & array[row + i][column + i].split('')).any?
      if (opponent_piece & array[row + i][column + i].split('')).any?
        array[row + i][column + i] = array[row + i][column + i].on_green
        @green_square_array << [row + i, column + i]
        break
      end
        array[row + i][column + i] = array[row + i][column + i].on_green
        @green_square_array << [row + i, column + i]
        i += 1
    end
    array
  end

  def upwards_diagonal(array, row, column, piece, opponent_piece)
    i = 1
    while row - i >= 0  && column - i >= 0
      break if (piece & array[row - i][column - i].split('')).any?
      if (opponent_piece & array[row - i][column - i].split('')).any?
        array[row - i][column - i] = array[row - i][column - i].on_green
        @green_square_array << [row - i, column - i]
        break
      end
      array[row - i][column - i] = array[row - i][column - i].on_green
      @green_square_array << [row - i, column - i]
      i += 1
    end
    array
  end

  def downwards_anti_diagonal(array, row, column, piece, opponent_piece)
    i = 1
    while row + i <= 7 && column - i >= 0
      break if (piece & array[row + i][column - i].split('')).any?
      if (opponent_piece & array[row + i][column - i].split('')).any?
        array[row + i][column - i] = array[row + i][column - i].on_green
        @green_square_array << [row + i, column - i]
        break
      end
        array[row + i][column - i] = array[row + i][column - i].on_green
        @green_square_array << [row + i, column - i]
        i += 1
    end
    array
  end

  def upwards_anti_diagonal(array, row, column, piece, opponent_piece)
    i = 1
    while row - i >= 0 && column + i <= 7
      break if (piece & array[row - i][column + i].split('')).any?
      if (opponent_piece & array[row - i][column + i].split('')).any?
        array[row - i][column + i] = array[row - i][column + i].on_green
        @green_square_array << [row - i, column + i]
        break
      end
        array[row - i][column + i] = array[row - i][column + i].on_green
        @green_square_array << [row - i, column + i]
        i += 1
    end
    array
  end
end
