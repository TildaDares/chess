require 'colorize'
require_relative 'knight'
require_relative 'rook'
require_relative 'pawn'
require_relative 'king'
require_relative 'bishop'
require_relative 'queen'
require_relative 'pieces'
class Board
  def initialize
    @array = populate_board
    @pieces = Pieces.new
    @rook = Rook.new
    @knight = Knight.new
    @pawn = Pawn.new
    @king = King.new
    @bishop = Bishop.new
    @queen = Queen.new
  end

  def self.check_for_checkmate
    @@check_for_checkmate
  end

  def self.check_for_check
    @@check_for_check
  end

  def print_board(array = @array)
    i = 8
    0.upto(7) do |j|
      print "#{i} #{array[j][0]}#{array[j][1]}#{array[j][2]}#{array[j][3]}#{array[j][4]}#{array[j][5]}#{array[j][6]}#{array[j][7]}\n"
      i -= 1
    end
    print "    a    b    c    d    e    f    g    h  \n"
  end

  def check_for_valid_square?(piece_to_play, coord)
    piece_to_play = piece_to_play.downcase
    coord = coord.downcase
    source_row, source_column = @pieces.change_alphabet_to_array(piece_to_play)
    row, column = @pieces.change_alphabet_to_array(coord)

    if @valid_squares.include?([row, column])
      castling_rules(coord)
      if @pawn.en_passant_moves[0] && @pawn.en_passant_moves[1] == [row, column]
        en_passant_true(piece_to_play, coord)
      elsif @king.castling_moves[0] && (coord == @king.castling_moves[1] || coord == @king.castling_moves[4])
        if piece_to_play == 'e1' || piece_to_play == 'e8'
          castling(piece_to_play, coord)
        end
      else
        @array[row][column] = @array[source_row][source_column]
        @array[source_row][source_column] = '     '
      end
      color_board(@array)
      if check?('black') || check?('white')
        puts "You're in check!".red
        @array = @global_board_array
      end
      return true
    end
    false
  end

  def castling_rules(coord)
    if coord == 'a8'
      @pieces.black_queenside_rook = true
    elsif coord == 'h8'
      @pieces.black_kingside_rook = true
    elsif coord == 'a1'
      @pieces.white_queenside_rook = true
    elsif coord == 'h1'
      @pieces.white_kingside_rook = true
    else
      # do nothing
    end
  end

  def castling(piece_to_play, coord)
    if coord == @king.castling_moves[1]
      king_dest = @king.castling_moves[1]
      rook_dest = @king.castling_moves[2]
      rook_loc = @king.castling_moves[3]
    end
    if @king.castling_moves.length > 4
      if coord == @king.castling_moves[4]
        king_dest = @king.castling_moves[4]
        rook_dest = @king.castling_moves[5]
        rook_loc = @king.castling_moves[6]
      end
    end
    rook_loc_row, rook_loc_column = @pieces.change_alphabet_to_array(rook_loc)
    king_loc_row, king_loc_column = @pieces.change_alphabet_to_array(piece_to_play)
    king_row, king_column = @pieces.change_alphabet_to_array(king_dest)
    rook_row, rook_column = @pieces.change_alphabet_to_array(rook_dest)
    @array[king_row][king_column] = @array[king_loc_row][king_loc_column]
    @array[king_loc_row][king_loc_column] = '     '
    @array[rook_row][rook_column] = @array[rook_loc_row][rook_loc_column]
    @array[rook_loc_row][rook_loc_column] = '     '
    @king.castling_moves = [false]
  end

  def en_passant_true(source, destination)
    source = source.downcase
    destination = destination.downcase
    source_row, source_column = @pieces.change_alphabet_to_array(source)
    row, column = @pieces.change_alphabet_to_array(destination)

    if @pawn.en_passant_moves[1] == [row, column]
      captured_row = @pawn.en_passant_moves[2][0]
      captured_column = @pawn.en_passant_moves[2][1]
      @array[row][column] = @array[source_row][source_column]
      @array[source_row][source_column] = '     '
      @array[captured_row][captured_column] = '     '
    end
    @pawn.en_passant_moves = [false]
  end

  def check?(color_piece, array = @array)
    copied_array = Marshal.load Marshal.dump(array)
    if color_piece == 'black'
      chess_piece = @pieces.black_pieces
    else
      chess_piece = @pieces.white_pieces
    end
    @@check_for_check = true
    @@check_for_checkmate = false
    king_coord = look_for_king(color_piece, array)
    array.each_with_index do |subarray, row|
      subarray.each_with_index do |sub_sub_array, column|
        next if (@pieces.all_chess_pieces & sub_sub_array.split('')).none?

        if (chess_piece & array[row][column].split('')).any?
          valid_squares = piece_method_to_call([row, column], copied_array, color_piece)
          valid_squares.each do |item|
            if item == king_coord
              @global_board_array = array
              @global_board_array[king_coord[0]][king_coord[1]] = array[king_coord[0]][king_coord[1]].on_red
              @@check_for_check = false
              return true 
            end
          end
        end
      end
    end
    @@check_for_check = false
    false
  end

  def checkmate_in_check?(color_piece)
    if checkmate?(color_piece) && check?(color_piece)
      print_board
      puts 'Checkmate!'.red
      if color_piece == 'black'
        puts 'Black wins! 0 - 1'.green
      else
        puts 'White wins! 1 - 0'.green
      end
      return true
    end
    false
  end

  def stalemate?(color_piece)
    if !check?(color_piece) && checkmate?(color_piece)
      print_board
      puts 'Stalemate!'.red
      puts '1/2 - 1/2'.blue
      return true
    end
    false
  end

  def promotion?(piece_to_change, color_piece)
    piece_to_change = piece_to_change.downcase
    row, column = @pieces.change_alphabet_to_array(piece_to_change)
    if /[♟♙]/ =~ @array[row][column]
      if color_piece == 'black' && row == 7
        return true
      end
      if color_piece == 'white' && row.zero?
        return true
      end
    end
    false
  end

  def promote(change_to, destination)
    destination = destination.downcase
    dest_row, dest_column = @pieces.change_alphabet_to_array(destination)
    @array[dest_row][dest_column] = change_to
    color_board(@array)
  end

  def check_game_board_pieces?(coord, color_piece)
    copied_array = Marshal.load Marshal.dump(@array)
    coord = coord.downcase
    row, column = @pieces.change_alphabet_to_array(coord)
    @@check_for_checkmate = false
    @@check_for_check = false
    if color_piece == 'black'
      chess_pieces = @pieces.black_pieces
    else
      chess_pieces = @pieces.white_pieces
    end
    if (chess_pieces & @array[row][column].split('')).any?
      is_there_a_move = piece_method_to_call(coord, copied_array, color_piece)
      print_board(@chess_piece_array)
      if is_there_a_move.empty?
        puts 'There are no moves to make from this square'
        return false
      else
        return true 
      end
    end
    puts "You're playing from the wrong side of the board"
    false
  end

  private

  def look_for_king(color_piece, array)
    array.each_with_index do |subarray, row|
      subarray.each_with_index do |sub_sub_array, column|
        if color_piece == 'white'
          if sub_sub_array.split('').include?('♚')
            return [row, column]
          end
        else
          if sub_sub_array.split('').include?('♔')
            return [row, column]
          end
        end
      end
    end
  end

  def piece_method_to_call(coord, array, color_piece)
    row, column = @pieces.change_alphabet_to_array(coord)
    if array[row][column].split('').include?('♟') || array[row][column].split('').include?('♙')
      @chess_piece_array = @pawn.pawn_move(array, coord, color_piece)
      valid_squares = @pawn.green_square_array
    elsif array[row][column].split('').include?('♜') || array[row][column].split('').include?('♖')
      @chess_piece_array = @rook.find_moves(array, coord, color_piece)
      valid_squares = @rook.green_square_array
    elsif array[row][column].split('').include?('♞') || array[row][column].split('').include?('♘')
      @chess_piece_array = @knight.create_children(coord, array, color_piece)
      valid_squares = @knight.green_square_array
    elsif array[row][column].split('').include?('♝') || array[row][column].split('').include?('♗')
      @chess_piece_array = @bishop.bishop_move(array, coord, color_piece)
      valid_squares = @bishop.green_square_array
    elsif array[row][column].split('').include?('♛') || array[row][column].split('').include?('♕')
      @chess_piece_array = @queen.queen_move(array, coord, color_piece)
      valid_squares = @queen.green_square_array
    elsif array[row][column].split('').include?('♚') || array[row][column].split('').include?('♔')
      @chess_piece_array = @king.king_move(array, coord, color_piece)
      valid_squares = @king.green_square_array
    end
    @valid_squares = valid_squares
    valid_squares
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
    # array[0][4] = '  ♚  '.black
  #  array[2][5]  = '  ♕  '
  #  array[0][7] = '  ♜  '.black
  #  array[7][4]  = '  ♔  '
  # array[1][4] = '  ♙  '
  # array[3][4]  = '  ♔  '
  # array[1][1]  = '  ♖  '
  # array[3][0]  = '  ♖  '
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

 def checkmate?(color_piece)
    copied_array = Marshal.load Marshal.dump(@array)
    row, column = look_for_king(color_piece, copied_array)
    king = King.new
    if color_piece == 'black'
      pass_color_piece = 'white'
      chess_piece = @pieces.white_pieces
    else
      pass_color_piece = 'black'
      chess_piece = @pieces.black_pieces
    end
    king.king_move(copied_array, [row, column], pass_color_piece)
    valid_squares = king.green_square_array
    @@check_for_checkmate = true
    @array.each_with_index do |subarray, row|
      subarray.each_with_index do |sub_sub_array, column|
        if (chess_piece & @array[row][column].split('')).any?
          next if /[♚♔]/ =~ sub_sub_array # skips checking kings because I've already checked

          piece_method_to_call([row, column], copied_array, pass_color_piece) # calls look_ahead method in Pieces class
          return false if @chess_piece_array.is_a?(Array) || @chess_piece_array
        end
      end
    end
    true if valid_squares.empty?
  end
end
