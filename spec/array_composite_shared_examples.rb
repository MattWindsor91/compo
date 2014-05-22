require 'compo'
require 'composite_shared_examples'

RSpec.shared_examples 'an array composite' do
  it_behaves_like 'a composite'

  # Children
  let(:c1) { double(:c1) }
  let(:c2) { double(:c2) }
  let(:c3) { double(:c3) }

  before(:each) do
    allow(c1).to receive(:update_parent)
    allow(c2).to receive(:update_parent)
    allow(c3).to receive(:update_parent)
  end

  describe '#add' do
    context 'when the ID is not Numeric' do
      specify { expect(subject.add(:mr_flibble, c1)).to be_nil }

      it 'does not add to the list of children' do
        expect { subject.add(:rimmer, c1) }.to_not change { subject.children }
                                           .from({})

        subject.add(0, c1)

        expect { subject.add(:lister, c2) }.to_not change { subject.children }
                                           .from(0 => c1)

        subject.add(1, c2)

        expect { subject.add(:cat, c3) }.to_not change { subject.children }
                                        .from(0 => c1, 1 => c2)
      end
    end
    context 'when the ID is Numeric' do
      context 'and is equal to the number of children' do
        it 'returns the child' do
          expect(subject.add(0, c1)).to eq(c1)
          expect(subject.add(1, c2)).to eq(c2)
          expect(subject.add(2, c3)).to eq(c3)
        end

        it 'adds to the end of the list of children' do
          expect(subject.children).to eq({})

          expect { subject.add(0, c1) }.to change { subject.children }
                                           .from({})
                                           .to(0 => c1)
          expect { subject.add(1, c2) }.to change { subject.children }
                                           .from(0 => c1)
                                           .to(0 => c1, 1 => c2)
          expect { subject.add(2, c3) }.to change { subject.children }
                                           .from(0 => c1, 1 => c2)
                                           .to(0 => c1, 1 => c2, 2 => c3)
        end

        it 'calls #update_parent on the child with itself and an ID proc' do
          expect(c1).to receive(:update_parent) do |parent, proc|
            expect(parent).to eq(subject)
            expect(proc.call).to eq(0)
          end
          subject.add(0, c1)
        end
      end

      context 'and is greater than the number of children' do
        it 'returns nil' do
          expect(subject.add(1, c1)).to be_nil
          subject.add(0, c1)
          expect(subject.add(2, c2)).to be_nil
          subject.add(1, c2)
          expect(subject.add(3, c3)).to be_nil
        end

        it 'does not add to the list of children' do
          expect { subject.add(1, c1) }.to_not change { subject.children }
                                       .from({})

          subject.add(0, c1)
          expect { subject.add(2, c2) }.to_not change { subject.children }
                                       .from(0 => c1)

          subject.add(1, c2)
          expect { subject.add(3, c2) }.to_not change { subject.children }
                                       .from(0 => c1, 1 => c2)
        end
      end

      context 'and is less than the number of children' do
        it 'returns the child' do
          subject.add(0, c1)
          expect(subject.add(0, c2)).to eq(c2)
          expect(subject.add(1, c3)).to eq(c3)
        end

        it 'adds to the list of children at the correct position' do
          expect(subject.children).to eq({})
          expect { subject.add(0, c1) }.to change { subject.children }
                                       .from({})
                                       .to(0 => c1)
          expect { subject.add(0, c2) }.to change { subject.children }
                                       .from(0 => c1)
                                       .to(0 => c2, 1 => c1)
          expect { subject.add(1, c3) }.to change { subject.children }
                                       .from(0 => c2, 1 => c1)
                                       .to(0 => c2, 1 => c3, 2 => c1)
        end

        it 'calls #update_parent on the child with itself and an ID proc' do
          expect(c1).to receive(:update_parent) do |parent, proc|
            expect(parent).to eq(subject)
            expect(proc.call).to eq(0)
          end
          subject.add(0, c2)
          subject.add(0, c1)
        end
      end
    end
  end

  describe '#remove' do
    context 'when the child exists in the list' do
      before(:each) { subject.add(0, c1) }

      it 'returns the child' do
        expect(subject.remove(c1)).to eq(c1)
      end

      it 'calls #update_parent on the child with a Parentless' do
        expect(c1).to receive(:update_parent).once do |parent, _|
          expect(parent).to be_a(Compo::Composites::Parentless)
        end
        subject.remove(c1)
      end

      it 'calls #update_parent on the child with a nil-returning ID proc' do
        expect(c1).to receive(:update_parent).once do |_, idp|
          expect(idp.call).to be_nil
        end
        subject.remove(c1)
      end

      it 'moves succeeding IDs down by one' do
        subject.add(1, c2)
        subject.add(2, c3)

        expect { subject.remove(c2) }.to change { subject.children }
                                     .from(0 => c1, 1 => c2, 2 => c3)
                                     .to(0 => c1, 1 => c3)
      end
    end

    context 'when the child does not exist in the list' do
      specify { expect(subject.remove(c1)).to be_nil }

      it 'does not change the children' do
        expect(subject.children).to eq({})
        expect { subject.remove(c1) }.to_not change { subject.children }
                                     .from({})

        subject.add(0, c1)
        subject.add(1, c2)
        expect { subject.remove(c3) }.to_not change { subject.children }
                                     .from eq(0 => c1, 1 => c2)
      end
    end
  end

  describe '#remove_id' do
    context 'when the ID exists' do
      before(:each) { subject.add(0, c1) }

      it 'returns the child' do
        expect(subject.remove_id(0)).to eq(c1)
      end

      it 'calls #update_parent on the child with a Parentless' do
        expect(c1).to receive(:update_parent).once do |parent, _|
          expect(parent).to be_a(Compo::Composites::Parentless)
        end
        subject.remove_id(0)
      end

      it 'calls #update_parent on the child with a nil-returning ID proc' do
        expect(c1).to receive(:update_parent).once do |_, idp|
          expect(idp.call).to be_nil
        end
        subject.remove_id(0)
      end

      it 'moves succeeding IDs down by one' do
        subject.add(1, c2)
        subject.add(2, c3)
        expect { subject.remove_id(1) }.to change { subject.children }
                                       .from(0 => c1, 1 => c2, 2 => c3)
                                       .to(0 => c1, 1 => c3)
      end
    end

    context 'when the ID does not exist' do
      specify { expect(subject.remove_id(0)).to be_nil }

      it 'does not change the children' do
        expect { subject.remove_id(0) }.to_not change { subject.children }
                                       .from({})

        subject.add(0, c1)
        subject.add(1, c2)
        expect { subject.remove_id(2) }.to_not change { subject.children }
                                       .from(0 => c1, 1 => c2)
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

        subject.add(0, c1)
        expect(subject.children).to eq(0 => c1)

        subject.add(1, c2)
        expect(subject.children).to eq(0 => c1, 1 => c2)

        subject.add(2, c3)
        expect(subject.children).to eq(0 => c1, 1 => c2, 2 => c3)

        subject.remove(c2)
        expect(subject.children).to eq(0 => c1, 1 => c3)

        subject.add(0, c2)
        expect(subject.children).to eq(0 => c2, 1 => c1, 2 => c3)
      end
    end
  end
end
