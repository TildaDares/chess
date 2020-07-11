require_relative 'game'
require_relative 'player'
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
  game = Game.new
  player1, player2 = game.players
  loop do
    break unless player1.move
    break unless player2.move
  end
else
  puts 'Choose a game'
  puts '1. barbs'
  puts '2. canyoubeatme'
  puts '3. hangman'
  puts '4. yourgame'
  game_choice = gets.chomp
  until /^[1234]$/ =~ game_choice
    puts 'Invalid!'.red
    puts 'Choose a game'
    puts '1. barbs'
    puts '2. canyoubeatme'
    puts '3. hangman'
    puts '4. Your saved game'
    game_choice = gets.chomp
  end
end
