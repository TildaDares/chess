# frozen_string_literal: true

require_relative 'player'
require_relative 'board'

# Game class
class Game
  def player1
    game_instruct
    puts "Input player 1's name"
    player_name1 = gets.chomp
    while player_name1.empty? || /\W/ =~ player_name1
      puts 'Enter a valid name'
      player_name1 = gets.chomp
    end
    @player1 = Player.new(player_name1, 'white')
    @player1
  end

  def player2
    puts "Input player 2's name"
    player_name2 = gets.chomp
    while player_name2.empty? || /\W/ =~ player_name2
      puts 'Enter a valid name'
      player_name2 = gets.chomp
    end
    @player2 = Player.new(player_name2, 'black')
    @player2
  end

  def game_instruct
    puts 'First player always gets the white pieces'
    puts 'Only last saved games can be played again. Your last game is always last on the list.'
    puts 'And it is saved with yourgame'
    puts "Enter 'save' during the game to save or 'exit' to exit the game\n\n"
  end
end
