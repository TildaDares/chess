require_relative 'rook'
require_relative 'bishop'
require_relative 'pieces'
class Queen < Pieces
  attr_reader :green_square_array
  def initialize
    super()
  end

  def queen_move(array, coord, color_piece)
    @green_square_array = []
    @array = array
    if color_piece == 'black'
      @opponent_color_piece = 'white'
      @symbol = '♛'
    else
      @opponent_color_piece = 'black'
      @symbol = '♕'
    end
    rook = Rook.new
    bishop = Bishop.new
    array = rook.find_moves(array, coord, color_piece)
    array = bishop.bishop_move(array, coord, color_piece)
    @green_square_array = rook.green_square_array + bishop.green_square_array
    return look_ahead(@green_square_array, @array, @symbol, @opponent_color_piece) if @check_for_checkmate == true
    array
  end
end