class Pieces
  attr_reader :all_chess_pieces, :white_pieces, :black_pieces
  attr_accessor :check_for_checkmate
  def initialize
    @check_for_checkmate = false
    @all_chess_pieces = ['♟', '♙', '♜', '♖', '♞', '♘', '♝', '♗', '♛', '♕', '♚', '♔']
    @white_pieces = ['♔', '♕', '♖', '♗', '♘', '♙']
    @black_pieces = ['♚', '♛', '♜', '♝', '♞', '♟']
  end

  def change_alphabet_to_array(source)
    return source[0], source[1] if source.kind_of?(Array)
    splited_source = source.split('')
    case splited_source[0]
    when 'a'
      column = 0
    when 'b'
      column = 1
    when 'c'
      column = 2
    when 'd'
      column = 3
    when 'e'
      column = 4
    when 'f'
      column = 5
    when 'g'
      column = 6
    when 'h'
      column= 7
    else
      return -1
    end
    row = change_number_to_array(splited_source[1])
    return row, column
  end

  def change_number_to_array(source)
    case source
    when '1'
      row = 7
    when '2'
      row = 6
    when '3'
      row = 5
    when '4'
      row = 4
    when '5'
      row = 3
    when '6'
      row = 2
    when '7'
      row = 1
    when '8'
      row = 0
    else
      return -1
    end
    row
  end

  private
  
  def look_ahead(green_square_array, array, symbol, opponent_color_piece)
    row, column = change_alphabet_to_array(coord)
    green_square_array.each do |array|
      board = Board.new
      copied_array = Marshal.load Marshal.dump(array)
      copied_array[row][column] = '    '
      copied_array[array[0]][array[1]] = symbol
      unless board.check?(opponent_color_piece, copied_array) 
        return true
      else
        next
      end
    end
    false
  end
end