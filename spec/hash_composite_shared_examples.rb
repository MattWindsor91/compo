require 'compo'
require 'composite_shared_examples'

RSpec.shared_examples 'a hash composite' do
  it_behaves_like 'a composite'

  let(:child1) { double(:child1) }
  let(:child2) { double(:child2) }
  let(:child3) { double(:child3) }

  before(:each) do
    allow(child1).to receive(:update_parent)
    allow(child2).to receive(:update_parent)
    allow(child3).to receive(:update_parent)
  end

  describe '#add' do
    context 'when the ID is occupied' do
      before(:each) { subject.add(:a, child1) }
      it 'returns the new child' do
        expect(subject.add(:a, child2)).to eq(child2)
      end

      it 'replaces the old child in the child hash' do
        expect { subject.add(:a, child2) }.to change { subject.children }
                                          .from(a: child1)
                                          .to(a: child2)
      end

      it 'calls #update_parent on the new child with itself and an ID proc' do
        expect(child2).to receive(:update_parent).once do |parent, proc|
          expect(parent).to eq(subject)
          expect(proc.call).to eq(:a)
        end
        subject.add(:a, child2)
      end

      it 'calls #update_parent on the old child with a Parentless' do
        expect(child1).to receive(:update_parent).once do |parent, _|
          expect(parent).to be_a(Compo::Composites::Parentless)
        end
        subject.add(:a, child2)
      end

      it 'calls #update_parent on the old child with nil-returning ID proc' do
        expect(child1).to receive(:update_parent).once do |_, idp|
          expect(idp.call).to be_nil
        end
        subject.add(:a, child2)
      end
    end

    context 'when the ID is not occupied' do
      it 'returns the child' do
        expect(subject.add(:a, child1)).to eq(child1)
        expect(subject.add(:b, child2)).to eq(child2)
        expect(subject.add(:c, child3)).to eq(child3)
      end

      it 'adds to the child hash' do
        expect(subject.children).to eq({})

        subject.add(:a, child1)
        expect(subject.children).to eq(a: child1)

        subject.add(:b, child2)
        expect(subject.children).to eq(a: child1, b: child2)

        subject.add(:c, child3)
        expect(subject.children).to eq(a: child1, b: child2, c: child3)
      end

      it 'calls #update_parent on the child with itself and an ID proc' do
        expect(child1).to receive(:update_parent) do |parent, proc|
          expect(parent).to eq(subject)
          expect(proc.call).to eq(:a)
        end
        subject.add(:a, child1)
      end
    end
  end

  describe '#remove' do
    context 'when the child exists in the hash' do
      before(:each) { subject.add(:a, child1) }

      it 'returns the child' do
        expect(subject.remove(child1)).to eq(child1)
      end

      it 'calls #update_parent on the child with a Parentless' do
        expect(child1).to receive(:update_parent).once do |parent, _|
          expect(parent).to be_a(Compo::Composites::Parentless)
        end
        subject.remove(child1)
      end

      it 'calls #update_parent on the child with a nil-returning ID proc' do
        expect(child1).to receive(:update_parent).once do |_, idp|
          expect(idp.call).to be_nil
        end
        subject.remove(child1)
      end

      it 'removes the child, and only the child, from the children hash' do
        subject.add(:b, child2)
        subject.add(:c, child3)

        expect { subject.remove(child2) }.to change { subject.children }
                                         .from(a: child1, b: child2, c: child3)
                                         .to(a: child1, c: child3)
      end
    end

    context 'when the child does not exist in the hash' do
      specify { expect(subject.remove(child1)).to be_nil }

      it 'does not change the children' do
        expect { subject.remove(child1) }.to_not change { subject.children }
                                         .from({})

        subject.add(:a, child1)
        subject.add(:b, child2)
        expect { subject.remove(child3) }.to_not change { subject.children }
                                         .from(a: child1, b: child2)
      end
    end
  end

  describe '#remove_id' do
    context 'when the ID exists' do
      before(:each) { subject.add(:a, child1) }

      it 'returns the child' do
        expect(subject.remove_id(:a)).to eq(child1)
      end

      it 'calls #update_parent on the child with a Parentless' do
        expect(child1).to receive(:update_parent).once do |parent, _|
          expect(parent).to be_a(Compo::Composites::Parentless)
        end
        subject.remove_id(:a)
      end

      it 'calls #update_parent on the child with a nil-returning ID proc' do
        expect(child1).to receive(:update_parent).once do |_, idp|
          expect(idp.call).to be_nil
        end
        subject.remove_id(:a)
      end

      it 'does not change the IDs of other children' do
        subject.add(:b, child2)
        subject.add(:c, child3)
        expect { subject.remove_id(:b) }.to change { subject.children }
                                        .from(a: child1, b: child2, c: child3)
                                        .to(a: child1, c: child3)
      end
    end

    context 'when the ID does not exist' do
      specify { expect(subject.remove_id(:a)).to be_nil }

      it 'does not change the children' do
        expect { subject.remove_id(:a) }.to_not change { subject.children }
                                        .from({})

        subject.add(:a, child1)
        subject.add(:b, child2)
        expect { subject.remove_id(:c) }.to_not change { subject.children }
                                        .from(a: child1, b: child2)
      end
    end
  end

  describe '#children' do
    context 'when the hash has no children' do
      it 'returns the empty hash' do
        expect(subject.children).to eq({})
      end
    end

    context 'when the hash has children' do
      it 'returns the current hash' do
        expect(subject.children).to eq({})

        subject.add(:a, child1)
        expect(subject.children).to eq(a: child1)

        subject.add(:b, child2)
        expect(subject.children).to eq(a: child1, b: child2)

        subject.add(:c, child3)
        expect(subject.children).to eq(a: child1, b: child2, c: child3)

        subject.remove(child2)
        expect(subject.children).to eq(a: child1, c: child3)

        subject.add(:a, child2)
        expect(subject.children).to eq(a: child2, c: child3)
      end
    end
  end
end
