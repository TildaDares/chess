require 'colorize'
require_relative 'pieces'
class Knight < Pieces
  attr_reader :green_square_array
  def initialize
    @chess_row = [-1, 2, 2, 1, -1, -2, -2, 1]
    @chess_col = [2, 1, -1, -2, -2, -1, 1, 2]
    super()
  end

  def create_children(coord, array, color_piece)
    @array = array
    @row, @column = change_alphabet_to_array(coord)
    if color_piece == 'black' 
      own_pieces = @black_pieces
      @opponent_color_piece = 'white'
      @symbol = '♞'
    else
      own_pieces = @white_pieces
      @opponent_color_piece = 'black'
      @symbol = '♘'
    end
    moves = []
    @green_square_array = []
    8.times do |i|
         moves << [@row + @chess_row[i], @column + @chess_col[i]]
    end
    valid_moves = moves.select do |coord|
        (coord[0] >= 0 && coord[0] <= 7) && (coord[1] >= 0 && coord[1] <= 7)
    end
    valid_moves.each do |valid_coord|
        next if (own_pieces & @array[valid_coord[0]][valid_coord[1]].split('')).any?
        @array[valid_coord[0]][valid_coord[1]] = array[valid_coord[0]][valid_coord[1]].on_green
        @green_square_array << [valid_coord[0], valid_coord[1]]
    end
    return look_ahead(@green_square_array, @array, @symbol, @opponent_color_piece) if @check_for_checkmate == true
    array
  end
end
