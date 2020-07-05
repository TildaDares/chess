require 'colorize'
class Pawn
  attr_reader :green_square_array
  def pawn_move(array, row, column, pieces, color_piece, opponent_pieces, all_pieces)
    @green_square_array = []
    if color_piece == 'black'
      add_row = row + 1
      add_row2 = row + 2
    else
      add_row = row - 1
      add_row2 = row - 2
    end

    if (row == 1 && color_piece == 'black') || (row == 6 && color_piece == 'white')
      pawn_first_move(add_row, all_pieces, array, column)
      pawn_second_move(add_row2, all_pieces, array, column)
    else
      pawn_second_move(add_row, all_pieces, array, column)
    end
    capture_diagonally(row, column, opponent_pieces, array, color_piece)
  end

  def pawn_first_move(add_row, all_pieces, array, column)
    return if (all_pieces & array[add_row][column].split('')).any? || add_row < 0 || add_row > 8
    array[add_row][column] = array[add_row][column].on_green
    @green_square_array << [add_row, column]
  end

  def pawn_second_move(add_row2, all_pieces, array, column)
    return if (all_pieces & array[add_row2][column].split('')).any? || add_row2 < 0 || add_row2 > 8
    array[add_row2][column] = array[add_row2][column].on_green
    @green_square_array << [add_row2, column]
  end

  def pawn_next_move(add_row, all_pieces, array, column)
    return if (all_pieces & array[add_row][column].split('')).any? || add_row < 0 || add_row > 8
    array[add_row][column] = array[add_row][column].on_green
    @green_square_array << [add_row, column]
  end

  def capture_diagonally(row, column, opponent_pieces, array, color_piece)
    if color_piece == 'white'
      capture_diagonally_for_white(row, column, array, opponent_pieces)
    else
      capture_diagonally_for_black(row, column, array, opponent_pieces)
    end
    array
  end

  def capture_diagonally_for_white(row, column, array, opponent_pieces)
    if row - 1 >= 0 && column - 1 >= 0
      if (opponent_pieces & array[row - 1][column - 1].split('')).any?
        array[row - 1][column - 1] = array[row - 1][column - 1].on_green
        @green_square_array << [row - 1, column - 1]
      end
    end
    if row - 1 >= 0 && column + 1 <= 7
      if (opponent_pieces & array[row - 1][column + 1].split('')).any?
        array[row - 1][column + 1] = array[row - 1][column + 1].on_green
        @green_square_array << [row - 1, column + 1]
      end
    end
  end

  def capture_diagonally_for_black(row, column, array, opponent_pieces)
    if row + 1 <= 7 && column - 1 >= 0
      if (opponent_pieces & array[row + 1][column - 1].split('')).any?
        array[row + 1][column - 1] = array[row + 1][column - 1].on_green
        @green_square_array << [row + 1, column - 1]
      end
    end
    if row + 1 <= 7 && column + 1 <= 7
      if (opponent_pieces & array[row + 1][column + 1].split('')).any?
        array[row + 1][column + 1] = array[row + 1][column + 1].on_green
        @green_square_array << [row + 1, column + 1]
      end
    end
  end
end
