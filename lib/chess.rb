# frozen_string_literal: true

require_relative 'game'
require_relative 'player'
require_relative 'computer'
require_relative 'board'
require 'colorize'

def check_instance(player)
  if player.instance_of?(Computer)
    Computer.new(player.piece)
  else
    Player.new(player.name, player.piece)
  end
end

def set_board(board, player)
  if player.instance_of?(Computer)
    Computer.set_board = board
  else
    Player.set_board = board
  end
end

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

player1 = nil
player2 = nil
if mode == '2'
  loop do
    puts 'Pick a game mode(select 1 or 2)'
    puts <<-OPTIONS
    1. Human vs Computer
    2. Human vs Human
    OPTIONS
    game_options = gets.chomp

    next unless /^[12]$/ =~ game_options

    game = Game.new
    player1 = game.player1
    player2 = if game_options == '1'
                Computer.new('black')
              else
                game.player2
              end
    break
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
  player1, player2, board_self = board.load_game(game_choice)
  player1 = check_instance(player1)
  player2 = check_instance(player2)
  set_board(board_self, player1)
  set_board(board_self, player2)
end

Board.player_attr = [player1, player2]
loop do
  break unless player1.move
  break unless player2.move
end
