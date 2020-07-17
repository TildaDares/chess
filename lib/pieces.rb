# frozen_string_literal: true

require 'colorize'

# Pieces class
class Pieces
  attr_reader :all_chess_pieces, :white_pieces, :black_pieces
  def initialize
    @all_chess_pieces = ['♟', '♙', '♜', '♖', '♞', '♘', '♝', '♗', '♛', '♕', '♚', '♔']
    @white_pieces = ['♔', '♕', '♖', '♗', '♘', '♙']
    @black_pieces = ['♚', '♛', '♜', '♝', '♞', '♟']
  end

  def change_alphabet_to_array(source)
    return source if source.is_a?(Array)

    splited_source = source.split('')
    column = case splited_source[0]
             when 'a'
               0
             when 'b'
               1
             when 'c'
               2
             when 'd'
               3
             when 'e'
               4
             when 'f'
               5
             when 'g'
               6
             when 'h'
               7
             else
               -1
             end
    row = change_number_to_array(splited_source[1])
    [row, column]
  end

  def change_number_to_array(source)
    row = case source
          when '1'
            7
          when '2'
            6
          when '3'
            5
          when '4'
            4
          when '5'
            3
          when '6'
            2
          when '7'
            1
          when '8'
            0
          else
            -1
          end
    row
  end

  private

  # The method places each piece's symbol in a possible location and checks if
  # that move will get it's king out of check and then RETURNS TRUE if it will and it
  # checks all the possible moves and not just the legal ones.
  # Board#check? has a boolean that makes sure the method doesn't have a stack overflow
  # because of the legal moves checks in each of
  # the piece's methods. #checkmate? makes use of this method
  def look_ahead(green_square_array, array, symbol, opponent_color_piece, coord)
    row, column = change_alphabet_to_array(coord)
    board = Board.new

    green_square_array.each do |green_array|
      copied_array = Marshal.load Marshal.dump(array)
      copied_array[row][column] = '    '
      copied_array[green_array[0]][green_array[1]] = symbol
      return true unless board.check?(opponent_color_piece, copied_array)
    end
    false
  end

  # removes illegal moves from the list of possible moves. The method is similar to #look_ahead but this one
  # calculates legal moves by placing each piece's symbol in each possible move on the board.
  # If that move results in a check for that piece's king then the move becomes illegal. This method does not run when
  # it is called by #check? or #checkmate?. Both methods have a boolean variable that prevents a stackoverflow
  def check_for_legal_moves(green_square_array, array, symbol, opponent_color_piece, coord)
    row, column = change_alphabet_to_array(coord)
    dup_possible_moves_array = Marshal.load Marshal.dump(green_square_array)

    dup_possible_moves_array.each do |possible_moves|
      dup_array = Marshal.load Marshal.dump(array)
      dup_array[row][column] = '     '
      dup_array[possible_moves[0]][possible_moves[1]] = symbol
      board = Board.new
      if board.check?(opponent_color_piece, dup_array)
        green_square_array.delete(possible_moves)
        next
      end

      array[possible_moves[0]][possible_moves[1]] = array[possible_moves[0]][possible_moves[1]].on_green
    end
  end
end
