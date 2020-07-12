require 'colorize'
require_relative 'pieces'
require_relative 'board'
class King < Pieces
  attr_reader :green_square_array
  attr_accessor :castling_moves
  def initialize
    @castling_moves = [false]
    @blacks_moves = []
    @white_moves = []
    super()
  end

  def king_move(array, coord, color_piece)
    @green_square_array = []
    @array = array
    @row, @column = change_alphabet_to_array(coord)
    if color_piece == 'black'
      @king = '  ♚  '
      @opponent_color_piece = 'white'
      @piece = @black_pieces
    else
      @king = '  ♔  '
      @opponent_color_piece = 'black'
      @piece = @white_pieces
    end
    movesets
    castling(color_piece, coord)
    unless Board.check_for_check
     color_piece == 'white' ? @white_moves << coord : @blacks_moves << coord
     check_for_legal_moves(@green_square_array, @array, @king, @opponent_color_piece, coord)
    end
    @array
  end

  private

  def movesets
    dr = [-1, -1, -1, 0, 0, +1, +1, +1]
    dc = [-1, 0, +1, -1, +1, -1, 0, +1]
    8.times do |i|
      if (@row + dr[i]).between?(0, 7) && (@column + dc[i]).between?(0, 7)
        unless (@piece & @array[@row + dr[i]][@column + dc[i]].split('')).any?
          @green_square_array << [@row + dr[i], @column + dc[i]]
        end
      end
    end
  end

  def castling(color_piece, coord)
    if color_piece == 'black'
      castling_black(coord)
    else
      castling_white(coord)
    end
  end

  def castling_black(coord)
    board = Board.new
    return unless @blacks_moves.empty?
    if coord == 'e8'
      if !@black_kingside_rook && !board.check?(@opponent_color_piece, @array) && nothing_in_between_king_and_rook('up')
        if (@column + 2).between?(0, 7) && !castling_through_check(@column + 1)
          @castling_moves[0] = true
          @castling_moves << 'g8' << 'f8' << 'h8'
          @green_square_array << [@row, @column + 2]
        end
      end
      if !@black_queenside_rook && !board.check?(@opponent_color_piece, @array) && nothing_in_between_king_and_rook('down')
        if (@column - 2).between?(0, 7) && !castling_through_check(@column - 1)
          @castling_moves[0] = true
          @castling_moves << 'c8' << 'd8' << 'a8'
          @green_square_array << [@row, @column - 2]
        end
      end
    end
  end

  def castling_white(coord)
    board = Board.new
    return unless @white_moves.empty?
    if coord == 'e1'
      if !@white_kingside_rook && !board.check?(@opponent_color_piece, @array) && nothing_in_between_king_and_rook('up')
        if (@column + 2).between?(0, 7) && !castling_through_check(@column + 1)
          @castling_moves[0] = true
          @castling_moves << 'g1' << 'f1' << 'h1'
          @green_square_array << [@row, @column + 2]
        end
      end
      if !@white_queenside_rook && !board.check?(@opponent_color_piece, @array) && nothing_in_between_king_and_rook('down')
        if (@column - 2).between?(0, 7) && !castling_through_check(@column - 1)
          @castling_moves[0] = true
          @castling_moves << 'c1' << 'd1' << 'a1'
          @green_square_array << [@row, @column - 2]
        end
      end
    end
  end

  def nothing_in_between_king_and_rook(direction)
    if direction == 'down'
      (@column - 1).downto(1) do |i|
        return false if (@all_chess_pieces & @array[@row][i].split('')).any?
      end
      true
    else
      (@column + 1).upto(6) do |i|
        return false if (@all_chess_pieces & @array[@row][i].split('')).any?
      end
      true
    end
  end

  def castling_through_check(column)
    board = Board.new
    dup_array = Marshal.load Marshal.dump(@array)
    dup_array[@row][@column] = '    '
    dup_array[@row][column] = @king
    return board.check?(@opponent_color_piece, dup_array)
  end
end
