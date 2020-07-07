require 'colorize'
require_relative 'pieces'
class Rook < Pieces
  attr_reader :green_square_array
  def initialize
    super()
  end

  def find_moves(array, coord, color_piece)
    @green_square_array = []
    @array = array
    if color_piece == 'black'
      @own_pieces = @black_pieces 
      @opponent_piece = @white_pieces
      @opponent_color_piece = 'white'
      @symbol = '♖'
      n = 7
    else
      @opponent_piece = @black_pieces
      @own_pieces = @white_pieces
      @opponent_color_piece = 'black'
      @symbol = '♜'
      n = 0
    end
    @row, @column = change_alphabet_to_array(coord)
    row_checker(n)
    column_checker
    return look_ahead(@green_square_array, @array, @symbol, @opponent_color_piece) if @check_for_checkmate == true
    @array
  end

  private

  def row_checker(n)
    i = @row
    j = @row
    loop do
      n == 7 ? i += 1 : i -=1
      break if i < 0 || i > 7
      break if (@own_pieces & @array[i][@column].split('')).any?
      if (@opponent_piece & @array[i][@column].split('')).any?
        @array[i][@column] = @array[i][@column].on_green
        @green_square_array << [i, @column]
        break
      end
      @array[i][@column] = @array[i][@column].on_green
      @green_square_array << [i, @column]
    end

    loop do
      n == 7 ? j -= 1 : j +=1
      break if j > 7 || j < 0
      break if (@own_pieces & @array[j][@column].split('')).any?
      if (@opponent_piece & @array[j][@column].split('')).any?
        @array[j][@column] = @array[j][@column].on_green
        @green_square_array << [j, @column]
        break
      end
      @array[j][@column] = @array[j][@column].on_green
      @green_square_array << [j, @column]
    end
  end

  def column_checker
    col = @column + 1
    col.upto(7) do |i|
      break if (@own_pieces & @array[@row][i].split('')).any?
      if (@opponent_piece & @array[@row][i].split('')).any?
        @array[@row][i] = @array[@row][i].on_green
        @green_square_array << [@row, i]
        break
      end
      @array[@row][i] = @array[@row][i].on_green
      @green_square_array << [@row, i]
    end

    col = @column - 1
    col.downto(0) do |i|
      break if (@own_pieces & @array[@row][i].split('')).any?
      if (@opponent_piece & @array[@row][i].split('')).any?
        @array[@row][i] = @array[@row][i].on_green
        @green_square_array << [@row, i]
        break
      end
      @array[@row][i] = @array[@row][i].on_green
      @green_square_array << [@row, i]
    end
  end
end
