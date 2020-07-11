require_relative 'rook'
require_relative 'bishop'
require_relative 'pieces'
require_relative 'board'
class Queen < Pieces
  attr_reader :green_square_array
  def initialize
    super()
  end

  def queen_move(array, coord, color_piece)
    @green_square_array = []
    if color_piece == 'black'
      opponent_color_piece = 'white'
      symbol = '♛'
    else
      opponent_color_piece = 'black'
      symbol = '♕'
    end
    rook = Rook.new
    bishop = Bishop.new
    rook.find_moves(array, coord, color_piece, false)
    bishop.bishop_move(array, coord, color_piece, false)
    @green_square_array = rook.green_square_array + bishop.green_square_array
    return look_ahead(@green_square_array, array, symbol, opponent_color_piece, coord) if Board.check_for_checkmate

    check_for_legal_moves(@green_square_array, array, symbol, opponent_color_piece, coord) unless Board.check_for_check
    array
  end
end
