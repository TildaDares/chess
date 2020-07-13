require_relative 'game'
require_relative 'player'
require_relative 'computer'
require_relative 'board'
require 'colorize'

puts 'Would you like to?'
puts '1. Load a game'
puts '2. Play new game'
mode = gets.chomp
until /^[12]$/ =~ mode
  puts 'Invalid!'.red
  puts 'Would you like to?'
  puts '1. Load a game'
  puts '2. Play new game'
  mode = gets.chomp
end

if mode == '2'
  player1 = nil
  player2 = nil
  loop do
    puts 'Pick a game mode(select 1 or 2)'
    puts <<-OPTIONS
    1. Human vs Computer
    2. Human vs Human
    OPTIONS
    game_options = gets.chomp

    if /^[12]$/ =~ game_options
      game = Game.new
      if game_options == '1'
        player1 = game.player1
        player2 = Computer.new('black')
      else
        player1 = game.player1
        player2 = game.player2
      end
      Board.player_attr = [player1, player2]
      break
    end
  end

  loop do
    break unless player1.move
    break unless player2.move
  end

else
  puts 'Choose a game mode'
  puts '1. canyoubeatme'
  puts '2. check'
  puts '3. youarerooked'
  puts '4. yourgame'
  game_choice = gets.chomp

  until /^[1234]$/ =~ game_choice
    puts 'Invalid!'.red
    puts 'Choose a game mode'
    puts '1. canyoubeatme'
    puts '2. check'
    puts '3. youarerooked'
    puts '4. yourgame'
    game_choice = gets.chomp
  end
  
  board = Board.new
  player1, player2 = board.load_game(game_choice)
  player1 = Player.new(player1.name, player1.piece)
  player2 = Player.new(player2.name, player2.piece)
  loop do
    break unless player1.move
    break unless player2.move
  end
end
