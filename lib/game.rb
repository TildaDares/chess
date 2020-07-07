require_relative 'player'
require_relative 'board'
class Game
  def players
    puts 'First player always gets the white pieces'
    puts "Input player 1's name"
    player_name1 = gets.chomp
    while player_name1.empty? || /\W/ =~ player_name1
      puts 'Enter a valid name'
      player_name1 = gets.chomp
    end
    @player1 = Player.new(player_name1, 'white')

    puts "Input player 2's name"
    player_name2 = gets.chomp
    while player_name2.empty? || /\W/ =~ player_name2
      puts 'Enter a valid name'
      player_name2 = gets.chomp
    end
    @player2 = Player.new(player_name2, 'black')
    return @player1, @player2
  end
end
