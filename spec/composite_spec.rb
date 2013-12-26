require 'spec_helper'
require 'compo'

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
end
