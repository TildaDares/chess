# frozen_string_literal: true

# Player class
class Player
  attr_reader :name, :piece
  def initialize(name, piece)
    @name = name
    @piece = piece
    @@board = Board.new
  end

  def self.set_board=(value)
    @@board = value
  end

  def move
    @@board.print_board
    puts "#{@name} what piece would you like to play? (e.g. a1, d3, d7) or enter 'save' to save game progress or 'quit' to quit"
    piece_to_play = gets.chomp
    return false unless verify_user_input(piece_to_play)

    until @@board.check_game_board_pieces?(piece_to_play, @piece)
      puts 'That piece cannot be reached'
      puts 'Enter a valid piece'
      piece_to_play = gets.chomp
      return false unless verify_user_input(piece_to_play)
    end
    move_to_square(piece_to_play)
  end

  private

  def move_to_square(piece_to_play)
    puts "#{@name} where would you like to move to? (e.g. a1, d3, d7) or enter 'save' to save game progress or 'quit' to quit"
    square_to_move_to = gets.chomp
    return false unless verify_user_input(square_to_move_to)

    until @@board.check_for_valid_square?(piece_to_play, square_to_move_to)
      puts 'That square cannot be reached'
      puts 'Enter a valid square'
      square_to_move_to = gets.chomp
      return false unless verify_user_input(square_to_move_to)
    end
    return false if @@board.stalemate?(@piece) || @@board.checkmate_in_check?(@piece)

    promote(square_to_move_to)
    true
  end

  def promote(square_to_move_to)
    return unless @@board.promotion?(square_to_move_to, @piece)

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
    promotion_for_piece(square_to_move_to, promote_to)
  end

  def change_piece_black(number)
    case number
    when '1'
      '  ♞  '
    when '2'
      '  ♛  '
    when '3'
      '  ♜  '
    when '4'
      '  ♝  '
    end
  end

  def change_piece_white(number)
    case number
    when '1'
      '  ♘  '
    when '2'
      '  ♕  '
    when '3'
      '  ♖  '
    when '4'
      '  ♗  '
    end
  end

  def promotion_for_piece(square_to_move_to, promote_to)
    if @piece == 'black'
      @@board.promote(change_piece_black(promote_to), square_to_move_to)
    else
      @@board.promote(change_piece_white(promote_to), square_to_move_to)
    end
  end

  def quit_or_save(user_choice)
    if /^save$/i =~ user_choice
      @@board.save_game(@piece)
      return false
    end
    return false if /^quit$/i =~ user_choice

    true
  end

  def verify_user_input(input)
    return false unless quit_or_save(input)

    while input.empty? || !(/^[a-h][1-8]$/i =~ input)
      puts 'Enter a valid piece'
      input = gets.chomp
      return false unless quit_or_save(input)
    end
    true
  end
end
