require_relative 'game'
require_relative 'player'
game = Game.new
player1, player2 = game.players
loop do
  break unless player1.move 
  break unless player2.move
end
