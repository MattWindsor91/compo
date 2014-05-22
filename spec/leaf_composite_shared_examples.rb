require 'composite_shared_examples'

RSpec.shared_examples 'a leaf composite' do
  it_behaves_like 'a composite'

  let(:c1) { double(:child1) }
  let(:c2) { double(:child2) }
  let(:c3) { double(:child3) }

  describe '#add' do
    it 'always returns nil' do
      expect(subject.add(  1, c1)).to be_nil
      expect(subject.add( :a, c2)).to be_nil
      expect(subject.add(nil, c3)).to be_nil
    end

    it 'does not change the result of #children' do
      expect { subject.add( 1, c1) }.to_not change { subject.children }.from({})
      expect { subject.add(:a, c2) }.to_not change { subject.children }.from({})
      expect { subject.add(:a, c3) }.to_not change { subject.children }.from({})
    end
  end

  describe '#remove' do
    specify { expect(subject.remove(c1)).to eq(nil) }

    it 'does not change the result of #children' do
      expect { subject.remove(c1) }.to_not change { subject.children }.from({})
      expect { subject.remove(c2) }.to_not change { subject.children }.from({})
      expect { subject.remove(c3) }.to_not change { subject.children }.from({})
    end
  end

  describe '#remove_id' do
    specify { expect(subject.remove_id(:a)).to eq(nil) }

    it 'does not change the result of #children' do
      expect(subject.children).to eq({})

      subject.remove_id(0)
      expect(subject.children).to eq({})

      subject.remove_id(:a)
      expect(subject.children).to eq({})

      subject.remove_id(nil)
      expect(subject.children).to eq({})
    end
  end

  describe '#children' do
    specify { expect(subject.children).to eq({}) }
  end
end
