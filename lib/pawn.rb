require 'colorize'
require_relative 'pieces'
require_relative 'board'
class Pawn < Pieces
  attr_reader :green_square_array
  attr_accessor :en_passant_moves, :en_passant_capture
  def initialize
    @blacks_moves = []
    @white_moves = []
    @en_passant_moves = [false]
    @en_passant_capture = []
    super()
  end

  def pawn_move(array, coord, color_piece)
    @green_square_array = []
    @array = array
    @color_piece = color_piece
    @row, @column = change_alphabet_to_array(coord)
    if @color_piece == 'black'
      @opponent_pieces = @white_pieces
      @opponent_color_piece = 'white'
      @symbol = '♟'
      add_row = @row + 1
      add_row2 = @row + 2
    else
      @opponent_pieces = @black_pieces
      @opponent_color_piece = 'black'
      @symbol = '♙'
      add_row = @row - 1
      add_row2 = @row - 2
    end
    pawn_first_move(add_row, add_row2)
    en_passant
    capture_diagonally
    return look_ahead(@green_square_array, @array, @symbol, @opponent_color_piece, coord) if Board.check_for_checkmate

    unless Board.check_for_check
      @color_piece == 'white' ? @white_moves << coord : @blacks_moves << coord
      check_for_legal_moves(@green_square_array, @array, @symbol, @opponent_color_piece, coord)
    end
    @array
  end

  private

  def pawn_first_move(add_row, add_row2)
    2.times do
      return if (@all_chess_pieces & @array[add_row][@column].split('')).any? || add_row.negative? || add_row > 8

      @green_square_array << [add_row, @column]
      return unless (@row == 1 && @color_piece == 'black') || (@row == 6 && @color_piece == 'white')

      add_row = add_row2
    end
  end

  def capture_diagonally
    @color_piece == 'white' ? dr = [-1, -1] : dr = [+1, +1]
    dc = [-1, +1]
    2.times do |i|
      if (@row + dr[i]).between?(0, 7) && (@column + dc[i]).between?(0, 7)
        if (@opponent_pieces & @array[@row + dr[i]][@column + dc[i]].split('')).any?
          @green_square_array << [@row + dr[i], @column + dc[i]]
        end
      end
    end
  end
  
  def en_passant
    return if @blacks_moves.empty? || @white_moves.empty?

    en_passant_black
    en_passant_white
  end

  def en_passant_black
    dr = [+1, +1]
    dc = [-1, +1]
    row, column = change_alphabet_to_array(@white_moves[-1])
    2.times do |i|
      if @color_piece == 'black' && row == 6 && @row == 4
        if (@column + dc[i]).between?(0, 7) && (@row + dr[i]).between?(0, 7)
          if column - @column == 1 || column - @column == -1
            if @array[@row][@column + dc[i]].split('').include?('♙')
              @en_passant_moves[0] = true
              @en_passant_moves << [@row + dr[i], @column + dc[i]] << [@row, @column + dc[i]]
              @green_square_array << [@row + dr[i], @column + dc[i]]
            end
          end
        end
      end
    end
  end

  def en_passant_white
    dr = [-1, -1]
    dc = [+1, -1]
    row, column = change_alphabet_to_array(@blacks_moves[-1])
    2.times do |i|
      if @color_piece == 'white' && row == 1 && @row == 3
        if (@column + dc[i]).between?(0, 7) && (@row + dr[i]).between?(0, 7)
          if column - @column == 1 || column - @column == -1
            if @array[@row][@column + dc[i]].split('').include?('♟')
              @en_passant_moves[0] = true
              @en_passant_moves << [@row + dr[i], @column + dc[i]] << [@row, @column + dc[i]]
              @green_square_array << [@row + dr[i], @column + dc[i]]
            end
          end
        end
      end
    end
  end
end
