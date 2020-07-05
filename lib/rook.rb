require 'colorize'
class Rook
  attr_reader :green_square_array
  def find_moves(array, row, column, pieces, color_piece, opponent_piece)
    @green_square_array = []
    color_piece == 'black' ? n = 7 : n = 0
    row_checker(row, column, pieces, array, n, opponent_piece)
    column_checker(row, column, pieces, array, opponent_piece)
    array
  end

  def row_checker(row, column, pieces, array, n, opponent_piece)
    i = row
    j = row
    loop do
      n == 7 ? i += 1 : i -=1
      break if i < 0 || i > 7
      break if (pieces & array[i][column].split('')).any?
      if (opponent_piece & array[i][column].split('')).any?
        array[i][column] = array[i][column].on_green
        @green_square_array << [i, column]
        break
      end
      array[i][column] = array[i][column].on_green
      @green_square_array << [i, column]
    end

    loop do
      n == 7 ? j -= 1 : j +=1
      break if j > 7 || j < 0
      break if (pieces & array[j][column].split('')).any?
      if (opponent_piece & array[j][column].split('')).any?
        array[j][column] = array[j][column].on_green
        @green_square_array << [j, column]
        break
      end
      array[j][column] = array[j][column].on_green
      @green_square_array << [j, column]
    end
  end

  def column_checker(row, column, pieces, array, opponent_piece)
    col = column + 1
    col.upto(7) do |i|
      break if (pieces & array[row][i].split('')).any?
      if (opponent_piece & array[row][i].split('')).any?
        array[row][i] = array[row][i].on_green
        @green_square_array << [row, i]
        break
      end
      array[row][i] = array[row][i].on_green
      @green_square_array << [row, i]
    end

    col = column - 1
    col.downto(0) do |i|
      break if (pieces & array[row][i].split('')).any?
      if (opponent_piece & array[row][i].split('')).any?
        array[row][i] = array[row][i].on_green
        @green_square_array << [row, i]
        break
      end
      array[row][i] = array[row][i].on_green
      @green_square_array << [row, i]
    end
  end
end
