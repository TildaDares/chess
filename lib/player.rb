require_relative 'game'
class Player
  attr_reader :name, :piece
  def initialize(name, piece, chess_pieces, opponent_pieces)
    @name = name
    @piece = piece
    @chess_pieces = chess_pieces
    @opponent_pieces = opponent_pieces
    @@board = Board.new
  end

  def move
    @@board.print_board
    puts "#{@name} what piece would you like to play? (e.g. a1, d3, d7)"
    piece_to_play = gets.chomp
    while piece_to_play.empty? || !(/^[a-h][1-8]$/ =~ piece_to_play)
      puts 'Enter a valid piece'
      piece_to_play = gets.chomp
    end
    until @@board.check_game_board_pieces?(piece_to_play, @piece, @chess_pieces, @opponent_pieces)
      puts 'That piece cannot be reached'
      puts 'Enter a valid piece'
      piece_to_play = gets.chomp
      while piece_to_play.empty? || !(/^[a-h][1-8]$/ =~ piece_to_play)
        puts 'Enter a valid piece'
        piece_to_play = gets.chomp
      end
    end
    return move_to_square(piece_to_play)
  end

  def move_to_square(piece_to_play)
    puts "#{@name} where would you like to move to? (e.g. a1, d3, d7)"
    square_to_move_to = gets.chomp
    while square_to_move_to.empty? || !(/^[a-h][1-8]$/ =~ square_to_move_to)
      puts 'Enter a valid piece'
      square_to_move_to = gets.chomp
    end
    until @@board.check_for_valid_square?(piece_to_play, square_to_move_to )
      puts 'That square cannot be reached'
      puts 'Enter a valid square'
      square_to_move_to = gets.chomp
      while square_to_move_to.empty? || !(/^[a-h][1-8]$/ =~ square_to_move_to )
        puts 'Enter a valid piece'
        square_to_move_to  = gets.chomp
      end
    end
    promote(square_to_move_to)
    if @@board.stalemate?
      puts 'Stalemate!'
      return false
    end
    true
  end

  def promote(square_to_move_to)
    if @@board.promotion?(square_to_move_to, @piece)
      puts 'What would you like your pawn to be?'
      puts <<-HEREDOC
      1. Knight
      2. Queen
      3. Rook
      4. Bishop
              HEREDOC
      promote_to = gets.chomp
      until /^[1234]$/ =~ promote_to
        puts 'You have to pick 1, 2, 3 or 4'
        puts 'What would you like your pawn to be?'
        puts <<-HEREDOC
          1. Knight
          2. Queen
          3. Rook
          4. Bishop
               HEREDOC
        promote_to = gets.chomp
      end
      if @piece == 'black'
        @@board.promote(change_piece_black(promote_to), square_to_move_to)
      else
        @@board.promote(change_piece_white(promote_to), square_to_move_to)
      end
    end
  end

  def change_piece_black(number)
    case number
    when '1'
      return '  ♞  '
    when '2'
      return '  ♛  '
    when '3'
      return '  ♝  '
    when '4'
      return '  ♜  '
    end
  end

  def change_piece_white(number)
    case number
    when '1'
      return '  ♘  '
    when '2'
      return '  ♕  '
    when '3'
      return '  ♗  '
    when '4'
      return '  ♖  '
    end
  end
end