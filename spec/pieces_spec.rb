require './lib/pieces'
describe Pieces do
  pieces = described_class.new
  describe '#change_alphabet_to_array' do
    context 'when it is given valid coordinates' do
      it 'returns [7, 2]' do
        expect(pieces.change_alphabet_to_array('c1')).to eql([7, 2])
      end
    end

    context 'when it is given an array' do
      it 'returns [0, 7]' do
        expect(pieces.change_alphabet_to_array([0, 7])).to eql([0, 7])
      end
    end

    context 'when it is given invalid coordinates' do
      it 'returns [-1, 5]' do
        expect(pieces.change_alphabet_to_array('f9')).to eql([-1, 5])
      end
    end
  end
end