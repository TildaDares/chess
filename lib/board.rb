require 'colorize'
require_relative 'knight'
require_relative 'rook'
require_relative 'pawn'
require_relative 'king'
require_relative 'bishop'
require_relative 'queen'
class Board
  attr_reader :pieces
  def initialize
    @array = populate_board
    @pieces = ['♟', '♙', '♜', '♖', '♞', '♘', '♝', '♗', '♛', '♕', '♚', '♔']
  end

  def populate_board
    array = Array.new(8) { Array.new(8) { '     ' } }
    0.upto(7) do |i|
      array[1][i] = '  ♟  '.black
      array[6][i] = '  ♙  '
    end
    array[0][0] = '  ♜  '.black
    array[7][0]  = '  ♖  '

    array[0][1] = '  ♞  '.black
    array[7][1]  = '  ♘  '

    array[0][2] = '  ♝  '.black
    array[7][2]  = '  ♗  '

    array[0][3] = '  ♛  '.black
    array[7][3]  = '  ♕  '

    array[0][4] = '  ♚  '.black
    array[7][4]  = '  ♔  '

    array[0][5] = '  ♝  '.black
    array[7][5]  = '  ♗  '

    array[0][6] = '  ♞  '.black
    array[7][6]  = '  ♘  '

    array[0][7] = '  ♜  '.black
    array[7][7]  = '  ♖  '
    colored_board_array = color_board(array)
    colored_board_array
  end

  def color_board(array)
    copied_array = array
    copied_array.each_with_index do |subarray, idx|
      subarray.each_with_index do |sub_sub_array, jdx|
        if idx.even?
          if jdx.even?
            array[idx][jdx] = sub_sub_array.on_light_black
          else
            array[idx][jdx] = sub_sub_array.on_light_white
          end
        else
          if jdx.odd?
            array[idx][jdx] = sub_sub_array.on_light_black
          else
            array[idx][jdx] = sub_sub_array.on_light_white
          end
        end
      end
    end
    array
  end

  def print_board(array = @array)
    i = 8
    0.upto(7) do |j|
        print "#{i} #{array[j][0]}#{array[j][1]}#{array[j][2]}#{array[j][3]}#{array[j][4]}#{array[j][5]}#{array[j][6]}#{array[j][7]}\n"
        i -= 1
    end
    print "    a    b    c    d    e    f    g    h  \n"
  end

  def change_alphabet_to_array(source)
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

  def piece_method_to_call?(row, column, array, color_piece, pieces, opponent_piece)
    rook = Rook.new
    knight = Knight.new
    pawn = Pawn.new
    king = King.new
    bishop = Bishop.new
    queen = Queen.new
    if array[row][column].split('').include?('♟') || array[row][column].split('').include?('♙')
      @chess_piece_array = pawn.pawn_move(array, row, column, pieces, color_piece, opponent_piece, @pieces)
      @valid_squares = pawn.green_square_array
    elsif array[row][column].split('').include?('♜') || array[row][column].split('').include?('♖')
      @chess_piece_array = rook.find_moves(array, row, column, pieces, color_piece, opponent_piece)
      @valid_squares = rook.green_square_array
    elsif array[row][column].split('').include?('♞') || array[row][column].split('').include?('♘')
      @chess_piece_array = knight.create_children(row, column, array, pieces)
      @valid_squares = knight.green_square_array
    elsif array[row][column].split('').include?('♝') || array[row][column].split('').include?('♗')
      @chess_piece_array = bishop.bishop_move(array, row, column, pieces, opponent_piece)
      @valid_squares = bishop.green_square_array
    elsif array[row][column].split('').include?('♛') || array[row][column].split('').include?('♕')
      @chess_piece_array = queen.queen_move(array, row, column, pieces, color_piece, opponent_piece)
      @valid_squares = queen.green_square_array
    elsif array[row][column].split('').include?('♚') || array[row][column].split('').include?('♔')
      @chess_piece_array = king.king_move(array, row, column, pieces)
      @valid_squares = king.green_square_array
    end
    @valid_squares.empty? ? false : true
  end

  def check_for_valid_square?(piece_to_play, coord)
    source_row, source_column = change_alphabet_to_array(piece_to_play)
    row, column = change_alphabet_to_array(coord)
    if @valid_squares.include?([row, column])
      @array[row][column] = @array[source_row][source_column]
      @array[source_row][source_column] = '     '
      color_board(@array)
      print_board
      return true
    end
    false
  end

  def stalemate? # still in testing stage
    white_pieces = ['♔', '♕', '♖', '♗', '♘', '♙']
    black_pieces = ['♚', '♛', '♜', '♝', '♞', '♟']
    copied_array = Marshal.load Marshal.dump(@array)
    available_moves = []
    @array.each_with_index do |subarray, row|
      subarray.each_with_index do |sub_sub_array, column|
        if (white_pieces & @array[row][column].split('')).any?
          piece_method_to_call?(row, column, copied_array, 'white', white_pieces, black_pieces)
          available_moves << @valid_squares
        end
        if (black_pieces & @array[row][column].split('')).any?
          piece_method_to_call?(row, column, copied_array, 'black', black_pieces, white_pieces)
          available_moves << @valid_squares
        end
      end
    end
    available_moves.flatten.empty? ? true : false
  end

  def promotion?(piece_to_change, color_piece)
    row, column = change_alphabet_to_array(piece_to_change)
    if /[♟♙]/ =~ @array[row][column]
      if color_piece == 'black' && row == 7
        return true
      end
      if color_piece == 'white' && row == 0
        return true
      end
    end
    false
  end

  def promote(change_to, destination)
    dest_row, dest_column = change_alphabet_to_array(destination)
    @array[dest_row][dest_column] = change_to
    color_board(@array)
  end

  def check_game_board_pieces?(coord, color_piece, chess_pieces, opponent_piece)
   copied_array = Marshal.load Marshal.dump(@array)
    row, column = change_alphabet_to_array(coord)
    if (chess_pieces & @array[row][column].split('')).any? 
      is_there_a_move = piece_method_to_call?(row, column, copied_array, color_piece, chess_pieces, opponent_piece)
      print_board(@chess_piece_array)
      return is_there_a_move
    end
      puts "You're playing from the wrong side of the board"
      false
  end
end