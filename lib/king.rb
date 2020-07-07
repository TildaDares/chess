require 'colorize'
require_relative 'pieces'
class King < Pieces
  attr_reader :green_square_array
  def initialize
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
    remove = -1
    one_sqr_apart = -2
    2.times do 
      sideways(remove)
      backwards_forward(remove)
      diagonals(remove)
      antidiagonals(remove)
      remove = 1
    end
    @array
  end

  private

  def sideways(remove)
    unless ((@column + remove) > 7 || (@column + remove) < 0)
      unless (@piece & @array[@row][@column + remove].split('')).any?
        unless ((@column + one_sqr_apart) > 7 || (@column + one_sqr_apart) < 0)
          return if /♚♔/ =~ @array[@row][@column + one_sqr_apart]
        end
        return if check_for_legal_moves([@row, @column + remove])
        @array[@row][@column + remove] = @array[@row][@column + remove].on_green
        @green_square_array << [@row, @column + remove]
      end
    end
  end

  def backwards_forward(remove)
    unless (@row + remove > 7 || @row + remove < 0)
      unless (@piece & @array[@row + remove][@column].split('')).any?
        unless (@row + one_sqr_apart > 7 || @row + one_sqr_apart < 0)
          return if /♚♔/ =~ @array[@row + one_sqr_apart][@column]
        end
        return if check_for_legal_moves([@row + remove, @column])
        @array[@row + remove][@column] = @array[@row + remove][@column].on_green
        @green_square_array << [@row + remove, @column]
      end
    end
  end

  def diagonals(remove)
    if ((@row + remove) >= 0 && (@row + remove) <= 7) && ((@column + remove) >= 0 && (@column + remove) <= 7)
      unless (@piece & @array[@row + remove][@column + remove].split('')).any?
        if ((@row + one_sqr_apart) >= 0 && (@row + one_sqr_apart) <= 7) && ((@column + one_sqr_apart) >= 0 && (@column + one_sqr_apart) <= 7)
          return if /♚♔/ =~ @array[@row + one_sqr_apart][@column + one_sqr_apart]
        end
        return if check_for_legal_moves([@row + remove, @column + remove])
        @array[@row + remove][@column + remove] = @array[@row + remove][@column + remove].on_green
        @green_square_array << [@row + remove, @column + remove]
      end
    end
  end

  def antidiagonals(remove)
    if ((@row - remove) <= 7 && (@row + remove) >= 0) || ((@row + remove) <= 7 && (@row - remove) >= 0)
      return if ((@column - remove) <= 7 && (@column + remove) >= 0) || ((@column + remove) <= 7 || (@column - remove) >= 0)
      unless (@piece & @array[@row - remove][@column + remove].split('')).any?
        unless ((@row - one_sqr_apart) <= 7 && (@row + one_sqr_apart) >= 0) || ((@row + one_sqr_apart) <= 7 && (@row - one_sqr_apart) >= 0)
          return if ((@column - one_sqr_apart) <= 7 && (@column + one_sqr_apart) >= 0) || ((@column + one_sqr_apart) <= 7 || (@column - one_sqr_apart) >= 0)
          return if /♚♔/ =~ @array[@row - one_sqr_apart][@column + one_sqr_apart]
        end
        return if check_for_legal_moves([@row - remove, @column + remove])
        @array[@row - remove][@column + remove] = @array[@row - remove][@column + remove].on_green
        @green_square_array << [@row - remove, @column + remove]
      end
    end
  end

  def check_for_legal_moves(possible_moves)
    dup_array = Marshal.load Marshal.dump(@array)
    dup_array[@row][@column] = '     '
    dup_array[possible_moves[0]][possible_moves[1]] = @king
    board = Board.new
    return board.check?(@opponent_color_piece, dup_array)
  end
end
