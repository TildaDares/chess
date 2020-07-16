require_relative 'player'
class Computer < Player
  def initialize(piece)
    @piece = piece
    @@board = Board.new
  end

  def move
    puts "Computer's turn"
    @@board.print_board
    square_to_move_to = @@board.computer_move_to(@piece)
    return false if @@board.stalemate?(@piece) || @@board.checkmate_in_check?(@piece)

    if @@board.promotion?(square_to_move_to, @piece)
      promotion_for_piece(square_to_move_to, %w[1 2 3 4].sample(1))
    end
    puts "Your turn"
    true
  end
end
