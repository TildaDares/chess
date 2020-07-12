# Chess Features
* En Passant
* Castling
* Stalemate
* Promotion
* Check
* Checkmate
* Legal moves are highlighted in green on the board
* Moves that puts or leaves a player's king in check are illegal
* Last moves are highlighted in yellow (start and end squares)
* A king in check is highlighted in red
* Only the last saved games and the games that were saved by me can be played
* It has an AI that plays randomly but when it's king is in check it protects it.

To play this game clone this repo and run:

                $ ruby lib/chess.rb

Note: The game relies heavily on gem colorize so before running the program, install the gem by running

                 $ gem install colorize

# Things to review
* The Board class is doing too much
* Methods need to be modular and do just one thing
* The fifty-move rule, threefold repetition and draw due to insufficient mating material should be implemented

If you'd like to know more about the game visit [Wikipedia](https://en.wikipedia.org/wiki/Chess) and the programming
exercise can be found at [The Odin Project](https://www.theodinproject.com/lessons/ruby-final-project).