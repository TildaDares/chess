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
  end

  def print_board(array = @array)
    i = 8
    0.upto(7) do |j|
        print "#{i} #{array[j][0]}#{array[j][1]}#{array[j][2]}#{array[j][3]}#{array[j][4]}#{array[j][5]}#{array[j][6]}#{array[j][7]}\n"
        i -= 1
    end
    print "    a    b    c    d    e    f    g    h  \n"
  end

  def check_for_valid_square?(piece_to_play, coord, color_piece)
    source_row, source_column = @pieces.change_alphabet_to_array(piece_to_play)
    row, column = @pieces.change_alphabet_to_array(coord)
    if @valid_squares.include?([row, column])
      @array[row][column] = @array[source_row][source_column]
      @array[source_row][source_column] = '     '
      color_board(@array)
      if check?('black') || check?('white')
        puts "You're in check"
        @array = @global_board_array
        return true
      end
      print_board(color_board(@array))
      return true
    end
    false
  end

  def check?(color_piece, array = @array) # still in testing stage
    copied_array = Marshal.load Marshal.dump(array)
    available_moves = []
    if color_piece == 'black' 
      chess_piece = @pieces.black_pieces
    else
      chess_piece = @pieces.white_pieces
    end
    array.each_with_index do |subarray, row|
      subarray.each_with_index do |sub_sub_array, column|
        next if /[♔♚]/ =~ sub_sub_array || !(@pieces.all_chess_pieces & sub_sub_array.split('')).any?
        if (chess_piece & array[row][column].split('')).any?
          valid_squares = piece_method_to_call([row, column], copied_array, color_piece)
          valid_squares.each do |item|
            available_moves << item
          end
        end
      end
    end
    king_coord = look_for_king(color_piece, array)
    if available_moves.include?(king_coord)
      @global_board_array = array
      @global_board_array[king_coord[0]][king_coord[1]] = array[king_coord[0]][king_coord[1]].on_red
      return true 
    end
  false
end

  def checkmate_in_check?(color_piece)
    if checkmate?(color_piece) && (check?('black') || check?('white'))
      puts 'Checkmate!'.red
      if color_piece == 'black'
        puts 'Black wins! 0 - 1'
      else
        puts 'White wins! 1 - 0'
      end
    end
  end

  def stalemate?(color_piece)
    if !check?(color_piece) && checkmate?(color_piece)
      puts 'Stalemate!'.red
      return true 
    end
    false
  end

  def promotion?(piece_to_change, color_piece)
    row, column = @pieces.change_alphabet_to_array(piece_to_change)
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
    dest_row, dest_column = @pieces.change_alphabet_to_array(destination)
    @array[dest_row][dest_column] = change_to
    color_board(@array)
  end

  def check_game_board_pieces?(coord, color_piece)
   copied_array = Marshal.load Marshal.dump(@array)
   row, column = @pieces.change_alphabet_to_array(coord)
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
          if array[row][column].split('').include?('♚')
            return [row, column]
          end
        else
          if array[row][column].split('').include?('♔')
            return [row, column]
          end
        end
      end
    end
  end

  def piece_method_to_call(coord, array, color_piece)
    rook = Rook.new
    knight = Knight.new
    pawn = Pawn.new
    king = King.new
    bishop = Bishop.new
    queen = Queen.new
    row, column = @pieces.change_alphabet_to_array(coord)
    if array[row][column].split('').include?('♟') || array[row][column].split('').include?('♙')
      @chess_piece_array = pawn.pawn_move(array, coord, color_piece)
      valid_squares = pawn.green_square_array
    elsif array[row][column].split('').include?('♜') || array[row][column].split('').include?('♖')
      @chess_piece_array = rook.find_moves(array, coord, color_piece)
      valid_squares = rook.green_square_array
    elsif array[row][column].split('').include?('♞') || array[row][column].split('').include?('♘')
      @chess_piece_array = knight.create_children(coord, array, color_piece)
      valid_squares = knight.green_square_array
    elsif array[row][column].split('').include?('♝') || array[row][column].split('').include?('♗')
      @chess_piece_array = bishop.bishop_move(array, coord, color_piece)
      valid_squares = bishop.green_square_array
    elsif array[row][column].split('').include?('♛') || array[row][column].split('').include?('♕')
      @chess_piece_array = queen.queen_move(array, coord, color_piece)
      valid_squares = queen.green_square_array
    elsif array[row][column].split('').include?('♚') || array[row][column].split('').include?('♔')
      @chess_piece_array = king.king_move(array, coord, color_piece)
      @king_possible_moves = king.green_square_array
      valid_squares = king.green_square_array
    end
    @valid_squares = valid_squares
    valid_squares
  end

  def populate_board
    array = Array.new(8) { Array.new(8) { '     ' } }
   0.upto(7) do |i|
     array[1][i] = '  ♟  '
     array[6][i] = '  ♙  '
   end
   array[0][0] = '  ♜  '
   array[7][0]  = '  ♖  '

   array[0][1] = '  ♞  '
   array[7][1]  = '  ♘  '

   array[0][2] = '  ♝  '
   array[7][2]  = '  ♗  '

   array[0][3] = '  ♛  '
   array[7][3]  = '  ♕  '

   array[0][4] = '  ♚  '
   array[7][4]  = '  ♔  '

   array[0][5] = '  ♝  '
   array[7][5]  = '  ♗  '

   array[0][6] = '  ♞  '
   array[7][6]  = '  ♘  '

   array[0][7] = '  ♜  '
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

 def checkmate?(color_piece)
  copied_array = Marshal.load Marshal.dump(@array)
  row, column = look_for_king(color_piece, copied_array)
  king = King.new
  available_moves = []
  if color_piece == 'black'
    pass_color_piece = 'white' 
    chess_piece = @pieces.white_pieces
  else
    pass_color_piece = 'black' 
    chess_piece = @pieces.black_pieces
  end
  valid_squares = piece_method_to_call([row, column], copied_array, pass_color_piece)
  piece = Pieces.new
  piece.check_for_checkmate = true
  @array.each_with_index do |subarray, row|
    subarray.each_with_index do |sub_sub_array, column|
      if (chess_piece & @array[row][column].split('')).any?
        return true if piece_method_to_call([row, column], copied_array, pass_color_piece) && valid_squares.empty?
      end
    end
  end
  piece.check_for_checkmate = false
  false
end
end