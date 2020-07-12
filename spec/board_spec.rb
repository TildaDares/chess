require './lib/board'
describe Board do
  board = described_class.new
  describe '#check?' do
    context 'when black is in check' do
      it 'returns true' do
        board_array = [
          ['', '', '♕', '', '♚'.black, '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          expect(board).to be_check('white', board_array)
      end
    end

    context 'when black is not in check' do
      it 'returns false' do
        board_array = [
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '♕', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          expect(board).to_not be_check('white', board_array)
      end
    end

    context 'when white is in check' do
      it 'returns true' do
        board_array = [
          ['', '', '♕', '', '♚'.black, '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '♜'.black, '', '♔', '', '', '']
          ]
          expect(board).to be_check('black', board_array)
      end
    end

    context 'when white is not in check' do
      it 'returns false' do
        board_array = [
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '♕', '', '♔', '', '', '']
          ]
          expect(board).to_not be_check('black', board_array)
      end
    end
  end

  describe '#checkmate_in_check?' do
    context 'when a black player is in checkmate' do
      it 'returns true' do
        board_array = [
          ['', '', '♕', '', '♚'.black, '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to be_checkmate_in_check('white')
      end
    end

    context 'when a black player is not in checkmate' do
      it 'returns false' do
        board_array = [
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '♕', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to_not be_checkmate_in_check('white')
      end
    end

    context 'when a white player is in checkmate' do
      it 'returns true' do
        board_array = [
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '', '♟'.black, '', '', ''],
          ['', '', '♛'.black, '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to be_checkmate_in_check('black')
      end
    end

    context 'when a white player is not in checkmate' do
      it 'returns false' do
        board_array = [
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '♙', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '♕', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to_not be_checkmate_in_check('black')
      end
    end
  end

  describe '#stalemate?' do
    context 'when a white player is in stalemate' do
      it 'returns true' do
        board_array = [
          ['', '', '♙', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '♜'.black, '♟'.black, '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to be_stalemate('black')
      end
    end

    context 'when a white player is not in stalemate' do
      it 'returns true' do
        board_array = [
          ['', '', '♕', '', '', '♚', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙'.black, '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to_not be_stalemate('black')
      end
    end

    context 'when a black player is in stalemate' do
      it 'returns true' do
        board_array = [
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to be_stalemate('white')
      end
    end

    context 'when a black player is not in stalemate' do
      it 'returns true' do
        board_array = [
          ['', '', '', '', '', '♚', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '♕', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to_not be_stalemate('white')
      end
    end
  end

  describe '#promotion?' do
    context "when a white pawn is in the first row of the black piece's side" do
      it 'returns true' do
        board_array = [
          ['♙', '', '', '', '', '♚', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '♕', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to be_promotion('a8', 'white')
      end
    end

    context "when a white pawn is not in the first row of the black piece's side" do
      it 'returns false' do
        board_array = [
          ['', '', '', '', '', '♚', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '♙', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '♕', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to_not be_promotion('b6', 'white')
      end
    end

    context "when a black pawn is in the first row of the white piece's side" do
      it 'returns true' do
        board_array = [
          ['', '', '', '', '', '♚', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '♕', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '♟', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to be_promotion('g1', 'black')
      end
    end

    context "when a black pawn is not in the first row of the white piece's side" do
      it 'returns false' do
        board_array = [
          ['', '', '', '', '', '♚', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '♙', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '♕', '', '', '', '♟', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to_not be_promotion('f4', 'white')
      end
    end

    context "when the piece is not a pawn" do
      it 'returns false' do
        board_array = [
          ['', '', '', '', '', '♚', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '♙', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '♕', '', '', '', '♟', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', '']
          ]
          board.instance_variable_set(:@array, board_array)
          expect(board).to_not be_promotion('b4', 'white')
      end
    end
  end
end