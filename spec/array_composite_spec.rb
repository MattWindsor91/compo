require 'spec_helper'
require 'compo'

shared_examples 'an array composite' do
  let(:child1) { double(:child1) }
  let(:child2) { double(:child2) }
  let(:child3) { double(:child3) }

  before(:each) do
    allow(child1).to receive(:update_parent)
    allow(child2).to receive(:update_parent)
    allow(child3).to receive(:update_parent)
  end

  describe '#add' do
    context 'when the ID is not Numeric' do
      specify { expect(subject.add(:mr_flibble, child1)).to be_nil }

      it 'does not add to the list of children' do
        subject.add(:rimmer, child1)
        expect(subject.children).to eq({})

        subject.add(0, child1)
        subject.add(:lister, child2)
        expect(subject.children).to eq(0 => child1)

        subject.add(1, child2)
        subject.add(:cat, child3)
        expect(subject.children).to eq(0 => child1, 1 => child2)
      end
    end
    context 'when the ID is Numeric' do
      context 'and is equal to the number of children' do
        it 'returns the child' do
          expect(subject.add(0, child1)).to eq(child1)
          expect(subject.add(1, child2)).to eq(child2)
          expect(subject.add(2, child3)).to eq(child3)
        end

        it 'adds to the end of the list of children' do
          expect(subject.children).to eq({})

          subject.add(0, child1)
          expect(subject.children).to eq(0 => child1)

          subject.add(1, child2)
          expect(subject.children).to eq(0 => child1, 1 => child2)

          subject.add(2, child3)
          expect(subject.children).to eq(0 => child1, 1 => child2, 2 => child3)
        end

        it 'calls #update_parent on the child with itself and an ID proc' do
          expect(child1).to receive(:update_parent) do |parent, proc|
            expect(parent).to eq(subject)
            expect(proc.call).to eq(0)
          end
          subject.add(0, child1)
        end
      end

      context 'and is greater than the number of children' do
        it 'returns nil' do
          expect(subject.add(1, child1)).to be_nil
          subject.add(0, child1)
          expect(subject.add(2, child2)).to be_nil
          subject.add(1, child2)
          expect(subject.add(3, child3)).to be_nil
        end

        it 'does not add to the list of children' do
          subject.add(1, child1)
          expect(subject.children).to eq({})

          subject.add(0, child1)
          subject.add(2, child2)
          expect(subject.children).to eq(0 => child1)

          subject.add(1, child2)
          subject.add(3, child3)
          expect(subject.children).to eq(0 => child1, 1 => child2)
        end
      end

      context 'and is less than the number of children' do
        it 'returns the child' do
          subject.add(0, child1)
          expect(subject.add(0, child2)).to eq(child2)
          expect(subject.add(1, child3)).to eq(child3)
        end

        it 'adds to the list of children at the correct position' do
          expect(subject.children).to eq({})
          subject.add(0, child1)
          expect(subject.children).to eq(0 => child1)
          subject.add(0, child2)
          expect(subject.children).to eq(0 => child2, 1 => child1)
          subject.add(1, child3)
          expect(subject.children).to eq(0 => child2, 1 => child3, 2 => child1)
        end

        it 'calls #update_parent on the child with itself and an ID proc' do
          expect(child1).to receive(:update_parent) do |parent, proc|
            expect(parent).to eq(subject)
            expect(proc.call).to eq(0)
          end
          subject.add(0, child2)
          subject.add(0, child1)
        end
      end
    end
  end

  describe '#remove' do
    context 'when the child exists in the list' do
      before(:each) { subject.add(0, child1) }

      it 'returns the child' do
        expect(subject.remove(child1)).to eq(child1)
      end

      it 'calls #update_parent on the child with a Parentless' do
        expect(child1).to receive(:update_parent).once do |parent, _|
          expect(parent).to be_a(Compo::Parentless)
        end
        subject.remove(child1)
      end

      it 'calls #update_parent on the child with a nil-returning ID proc' do
        expect(child1).to receive(:update_parent).once do |_, idp|
          expect(idp.call).to be_nil
        end
        subject.remove(child1)
      end

      it 'moves succeeding IDs down by one' do
        subject.add(1, child2)
        subject.add(2, child3)
        expect(subject.children).to eq(0 => child1, 1 => child2, 2 => child3)
        subject.remove(child2)
        expect(subject.children).to eq(0 => child1, 1 => child3)
      end
    end

    context 'when the child does not exist in the list' do
      specify { expect(subject.remove(child1)).to be_nil }

      it 'does not change the children' do
        expect(subject.children).to eq({})
        subject.remove(child1)
        expect(subject.children).to eq({})

        subject.add(0, child1)
        subject.add(1, child2)
        expect(subject.children).to eq(0 => child1, 1 => child2)
        subject.remove(child3)
        expect(subject.children).to eq(0 => child1, 1 => child2)
      end
    end
  end

  describe '#remove_id' do
    context 'when the ID exists' do
      before(:each) { subject.add(0, child1) }

      it 'returns the child' do
        expect(subject.remove_id(0)).to eq(child1)
      end

      it 'calls #update_parent on the child with a Parentless' do
        expect(child1).to receive(:update_parent).once do |parent, _|
          expect(parent).to be_a(Compo::Parentless)
        end
        subject.remove_id(0)
      end

      it 'calls #update_parent on the child with a nil-returning ID proc' do
        expect(child1).to receive(:update_parent).once do |_, idp|
          expect(idp.call).to be_nil
        end
        subject.remove_id(0)
      end

      it 'moves succeeding IDs down by one' do
        subject.add(1, child2)
        subject.add(2, child3)
        expect(subject.children).to eq(0 => child1, 1 => child2, 2 => child3)
        subject.remove_id(1)
        expect(subject.children).to eq(0 => child1, 1 => child3)
      end
    end

    context 'when the ID does not exist' do
      specify { expect(subject.remove_id(0)).to be_nil }

      it 'does not change the children' do
        expect(subject.children).to eq({})
        subject.remove_id(0)
        expect(subject.children).to eq({})

        subject.add(0, child1)
        subject.add(1, child2)
        expect(subject.children).to eq(0 => child1, 1 => child2)
        subject.remove_id(2)
        expect(subject.children).to eq(0 => child1, 1 => child2)
      end
    end
  end

  describe '#children' do
    context 'when the list has no children' do
      it 'returns the empty hash' do
        expect(subject.children).to eq({})
      end
    end

    context 'when the list has children' do
      it 'returns a hash mapping their current indices to themselves' do
        expect(subject.children).to eq({})

        subject.add(0, child1)
        expect(subject.children).to eq(0 => child1)

        subject.add(1, child2)
        expect(subject.children).to eq(0 => child1, 1 => child2)

        subject.add(2, child3)
        expect(subject.children).to eq(0 => child1, 1 => child2, 2 => child3)

        subject.remove(child2)
        expect(subject.children).to eq(0 => child1, 1 => child3)

        subject.add(0, child2)
        expect(subject.children).to eq(0 => child2, 1 => child1, 2 => child3)
      end
    end
  end
end

describe Compo::ArrayComposite do
  it_behaves_like 'an array composite'
end
