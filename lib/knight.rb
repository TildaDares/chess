require 'colorize'
class Knight
    attr_reader :green_square_array
  def initialize
      @chess_row = [-1, 2, 2, 1, -1, -2, -2, 1]
      @chess_col = [2, 1, -1, -2, -2, -1, 1, 2]
  end

  def create_children(row, column, array, pieces)
      moves = []
      @green_square_array = []
      8.times do |i|
          moves << [row + @chess_row[i], column + @chess_col[i]]
      end
      valid_moves = moves.select do |coord|
          (coord[0] >= 0 && coord[0] <= 7) && (coord[1] >= 0 && coord[1] <= 7)
      end
      valid_moves.each do |valid_coord|
        next if (pieces & array[valid_coord[0]][valid_coord[1]].split('')).any?
        array[valid_coord[0]][valid_coord[1]] = array[valid_coord[0]][valid_coord[1]].on_green
        @green_square_array << [valid_coord[0], valid_coord[1]]
      end
      array
  end
end