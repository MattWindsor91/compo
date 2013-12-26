require 'spec_helper'
require 'compo'

describe Compo::NullComposite do
  let(:child1) { double(:child1) }
  let(:child2) { double(:child2) }
  let(:child3) { double(:child3) }

  describe '#add' do
    it 'always returns nil' do
      expect(subject.add(1, child1)).to be_nil
      expect(subject.add(:a, child2)).to be_nil
      expect(subject.add(nil, child3)).to be_nil
    end

    it 'does not change the result of #children' do
      expect(subject.children).to eq({})

      subject.add(1, child1)
      expect(subject.children).to eq({})

      subject.add(:a, child2)
      expect(subject.children).to eq({})

      subject.add(:a, child3)
      expect(subject.children).to eq({})
    end
  end

  describe '#remove' do
    specify { expect(subject.remove(child1)).to eq(nil) }

    it 'does not change the result of #children' do
      expect(subject.children).to eq({})

      subject.remove(child1)
      expect(subject.children).to eq({})

      subject.remove(child2)
      expect(subject.children).to eq({})

      subject.remove(child3)
      expect(subject.children).to eq({})
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
