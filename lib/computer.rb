# frozen_string_literal: true

require_relative 'player'

# Computer class
class Computer < Player
  def initialize(piece)
    @piece = piece
    @@board = Board.new
  end

  def self.set_board=(value)
    @@board = value
  end

  def move
    puts "Computer's turn"
    @@board.print_board
    square_to_move_to = @@board.computer_move_to(@piece)
    return false if @@board.stalemate?(@piece) || @@board.checkmate_in_check?(@piece)

    promotion_for_piece(square_to_move_to, %w[1 2 3 4].sample(1)) if @@board.promotion?(square_to_move_to, @piece)
    puts 'Your turn'
    true
  end
end
