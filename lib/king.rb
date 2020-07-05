require 'colorize'
class King
  attr_reader :green_square_array
  def king_move(array, row, column, piece)
    @green_square_array = []
    remove = -1
    2.times do 
      unless ((column + remove) > 7 || (column + remove) < 0)
        unless (piece & array[row][column + remove].split('')).any?
          array[row][column + remove] = array[row][column + remove].on_green
          @green_square_array << [row, column + remove]
        end
      end
      unless (row + remove > 7 || row + remove < 0)
        unless (piece & array[row + remove][column].split('')).any?
          array[row + remove][column] = array[row + remove][column].on_green
          @green_square_array << [row + remove, column]
        end
      end
      remove = 1
    end
    array
  end
end