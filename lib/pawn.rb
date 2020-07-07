require 'colorize'
require_relative 'pieces'
class Pawn < Pieces
  attr_reader :green_square_array
  def initialize
    super()
  end

  def pawn_move(array, coord, color_piece)
    @green_square_array = []
    @array = array
    @color_piece = color_piece
    if @color_piece == 'black' 
      @opponent_pieces = @white_pieces
      @opponent_color_piece = 'white'
      @symbol = '♟'
      add_row = @row + 1
      add_row2 = @row + 2
    else
      @opponent_pieces = @black_pieces
      @opponent_color_piece = 'black'
      @symbol = '♙'
      add_row = @row - 1
      add_row2 = @row - 2
    end
    @row, @column = change_alphabet_to_array(coord)
    if (@row == 1 && @color_piece == 'black') || (@row == 6 && @color_piece == 'white')
      pawn_first_move(add_row)
      pawn_second_move(add_row2)
    else
      pawn_second_move(add_row)
    end
    capture_diagonally
  end

  private
  
  def pawn_first_move(add_row)
    return if (@all_chess_pieces & @array[add_row][@column].split('')).any? || add_row < 0 || add_row > 8
    @array[add_row][@column] = @array[add_row][@column].on_green
    @green_square_array << [add_row, @column]
  end

  def pawn_second_move(add_row2)
    return if (@all_chess_pieces & @array[add_row2][@column].split('')).any? || add_row2 < 0 || add_row2 > 8
    @array[add_row2][@column] = @array[add_row2][@column].on_green
    @green_square_array << [add_row2, @column]
  end

  def pawn_next_move(add_row)
    return if (@all_chess_pieces & @array[add_row][@column].split('')).any? || add_row < 0 || add_row > 8
    @array[add_row][@column] = @array[add_row][@column].on_green
    @green_square_array << [add_row, @column]
  end

  def capture_diagonally
    if @color_piece == 'white'
      capture_diagonally_for_white
    else
      capture_diagonally_for_black
    end
    return look_ahead(@green_square_array, @array, @symbol, @opponent_color_piece) if @check_for_checkmate == true
    @array
  end

  def capture_diagonally_for_white
    if @row - 1 >= 0 && @column - 1 >= 0
      if (@opponent_pieces & @array[@row - 1][@column - 1].split('')).any?
        @array[@row - 1][@column - 1] = @array[@row - 1][@column - 1].on_green
        @green_square_array << [@row - 1, @column - 1]
      end
    end
    if @row - 1 >= 0 && @column + 1 <= 7
      if (@opponent_pieces & @array[@row - 1][@column + 1].split('')).any?
        @array[@row - 1][@column + 1] = @array[@row - 1][@column + 1].on_green
        @green_square_array << [@row - 1, @column + 1]
      end
    end
  end

  def capture_diagonally_for_black
    if @row + 1 <= 7 && @column - 1 >= 0
      if (@opponent_pieces & @array[@row + 1][@column - 1].split('')).any?
        @array[@row + 1][@column - 1] = @array[@row + 1][@column - 1].on_green
        @green_square_array << [@row + 1, @column - 1]
      end
    end
    if @row + 1 <= 7 && @column + 1 <= 7
      if (@opponent_pieces & @array[@row + 1][@column + 1].split('')).any?
        @array[@row + 1][@column + 1] = @array[@row + 1][@column + 1].on_green
        @green_square_array << [@row + 1, @column + 1]
      end
    end
  end
end
