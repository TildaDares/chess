require_relative 'rook'
require_relative 'bishop'
class Queen
  attr_reader :green_square_array
  def queen_move(array, row, column, piece, color_piece, opponent_piece)
    @green_square_array = []
    rook = Rook.new
    bishop = Bishop.new
    array = rook.find_moves(array, row, column, piece, color_piece, opponent_piece)
    array = bishop.bishop_move(array, row, column, piece, opponent_piece)
    @green_square_array = rook.green_square_array + bishop.green_square_array
    array
  end
end