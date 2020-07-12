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

  describe '#check_in_checkmate?' do
    context 'when a white player is in checkmate' do
      it 'returns true' do
        board_array = [
          ['', '', '', '', '♚'.black, '', '', ''],
          ['', '', '', '', '♙', '', '', ''],
          ['', '', '', '', '♔', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '', ''],
          ['', '', '♕', '', '', '', '', '']
          ]
      end
    end
  end
end