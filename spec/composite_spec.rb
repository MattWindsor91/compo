require 'spec_helper'
require 'compo'

# Mock implementation of a Composite
class MockComposite
  include Compo::Composite
end

describe MockComposite do
  let(:id) { double(:id) }
  let(:child) { double(:child) }

  describe '#add' do
    before(:each) { allow(subject).to receive(:add!) }

    context 'when #add! returns nil' do
      before(:each) { allow(subject).to receive(:add!).and_return(nil) }

      specify { expect(subject.add(id, child)).to be_nil }

      it 'calls #add! with the ID and child given' do
        expect(subject).to receive(:add!).once.with(id, child)
        subject.add(id, child)
      end
    end

    context 'when #add! returns the child' do
      before(:each) do
        allow(subject).to receive(:add!).and_return(child)
        allow(subject).to receive(:id_function)
        allow(child).to receive(:update_parent)
      end

      it 'calls #add! with the ID and child given' do
        expect(subject).to receive(:add!).once.with(id, child)
        subject.add(id, child)
      end

      it 'calls #id_function with the child given' do
        expect(subject).to receive(:id_function).once.with(child)
        subject.add(id, child)
      end

      it 'calls #update_parent on the child with the parent and ID function' do
        idf = double(:id_function)
        allow(subject).to receive(:id_function).and_return(idf)
        expect(child).to receive(:update_parent).once.with(subject, idf)
        subject.add(id, child)
      end

      it 'returns the given child' do
        expect(subject.add(id, child)).to eq(child)
      end
    end
  end

  describe '#remove' do
    context 'when #remove! is defined' do
      before(:each) { allow(subject).to receive(:remove!) }

      context 'when #remove! returns nil' do
        before(:each) { allow(subject).to receive(:remove!).and_return(nil) }

        specify { expect(subject.remove(child)).to be_nil }

        it 'calls #remove! with the child given' do
          expect(subject).to receive(:remove!).once.with(child)
          subject.remove(child)
        end
      end

      context 'when #remove! returns the child' do
        before(:each) do
          allow(subject).to receive(:remove!).and_return(child)
          allow(child).to receive(:remove_parent)
        end

        it 'calls #remove! with the child given' do
          expect(subject).to receive(:remove!).once.with(child)
          subject.remove(child)
        end

        it 'calls #remove_parent on the child with no arguments' do
          expect(child).to receive(:remove_parent).once.with(no_args)
          subject.remove(child)
        end

        it 'returns the given child' do
          expect(subject.remove(child)).to eq(child)
        end
      end
    end

    context 'when #remove_id! is defined but #remove! is not' do
      before(:each) do
        allow(subject).to receive(:remove_id!)
        allow(subject).to receive(:children).and_return(id => child)
      end

      context 'when #remove_id! returns nil' do
        before(:each) do
          allow(subject).to receive(:remove_id!).and_return(nil)
        end

        specify { expect(subject.remove(child)).to be_nil }

        it 'calls #remove! with the child given' do
          expect(subject).to receive(:remove!).once.with(child)
          subject.remove(child)
        end

        it 'calls #remove_id! with the ID of the child' do
          expect(subject).to receive(:remove_id!).once.with(id)
          subject.remove(child)
        end

        it 'calls #children' do
          expect(subject).to receive(:children).once
          subject.remove(child)
        end
      end

      context 'when #remove_id! returns the child' do
        before(:each) do
          allow(subject).to receive(:remove_id!).and_return(child)
          allow(child).to receive(:remove_parent)
        end

        it 'calls #remove_id! with the child given' do
          expect(subject).to receive(:remove!).once.with(child)
          subject.remove(child)
        end

        it 'calls #remove_parent on the child with no arguments' do
          expect(child).to receive(:remove_parent).once.with(no_args)
          subject.remove(child)
        end

        it 'returns the given child' do
          expect(subject.remove(child)).to eq(child)
        end
      end
    end
  end

  describe '#remove_id' do
    let(:id) { double(:id) }

    context 'when #remove_id! is defined' do
      before(:each) { allow(subject).to receive(:remove_id!) }

      context 'and #remove_id! returns nil' do
        before(:each) do
          allow(subject).to receive(:remove_id!).and_return(nil)
        end

        specify { expect(subject.remove_id(id)).to be_nil }

        it 'calls #remove_id! with the ID given' do
          expect(subject).to receive(:remove_id!).once.with(id)
          subject.remove_id(id)
        end
      end

      context 'and #remove_id! returns the child' do
        before(:each) do
          allow(subject).to receive(:remove_id!).and_return(child)
          allow(child).to receive(:remove_parent)
        end

        it 'calls #remove_id! with the ID given' do
          expect(subject).to receive(:remove_id!).once.with(id)
          subject.remove_id(id)
        end

        it 'calls #remove_parent on the child with no arguments' do
          expect(child).to receive(:remove_parent).once.with(no_args)
          subject.remove_id(id)
        end

        it 'returns the child' do
          expect(subject.remove_id(id)).to eq(child)
        end
      end
    end

    context 'when #remove! is defined but #remove_id! is not' do
      before(:each) { allow(subject).to receive(:remove!) }

      context 'and #remove! returns nil' do
        before(:each) do
          allow(subject).to receive(:remove!).and_return(nil)
          allow(subject).to receive(:get_child).and_return(child)
        end

        specify { expect(subject.remove_id(id)).to be_nil }

        it 'calls #remove_id! with the ID given' do
          expect(subject).to receive(:remove_id!).once.with(id)
          subject.remove_id(id)
        end

        it 'calls #get_child with the ID given' do
          expect(subject).to receive(:get_child).once.with(id)
          subject.remove_id(id)
        end

        it 'calls #remove! with the child given' do
          expect(subject).to receive(:remove!).once.with(child)
          subject.remove_id(id)
        end
      end

      context 'and #remove! returns the child' do
        before(:each) do
          allow(subject).to receive(:remove!).and_return(child)
          allow(subject).to receive(:get_child).and_return(child)
          allow(child).to receive(:remove_parent)
        end

        it 'calls #remove! with the child given' do
          expect(subject).to receive(:remove!).once.with(child)
          subject.remove_id(id)
        end

        it 'calls #remove_parent on the child with no arguments' do
          expect(child).to receive(:remove_parent).once.with(no_args)
          subject.remove_id(id)
        end

        it 'returns the given child' do
          expect(subject.remove_id(id)).to eq(child)
        end
      end
    end
  end

  describe '#each' do
    it 'delegates to the #each implementation of the hash from #children' do
      children = double(:children)

      allow(subject).to receive(:children).and_return(children)
      expect(subject).to receive(:children).once.with(no_args)
      expect(children).to receive(:each).once

      subject.each
    end
  end
end
