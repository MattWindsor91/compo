RSpec.shared_examples 'a URL referenceable object' do
  let(:parent) { nil }
  let(:id) { double(:id) }

  before(:each) { allow(subject).to receive_messages(id: id, parent: parent) }

  describe '#url' do
    context 'when the UrlReferenceable has no parent' do
      specify { expect { subject.url }.to raise_error }
    end

    context 'when the UrlReferenceable has a parent' do
      let(:parent) { double(:parent) }
      before(:each) do
        allow(parent).to receive(:child_url).and_return(:child_url)
      end

      it 'calls #id' do
        subject.url
        expect(subject).to have_received(:id)
      end

      it 'calls #parent' do
        subject.url
        expect(subject).to have_received(:parent)
      end

      it 'calls #child_url on the parent with the ID' do
        subject.url
        expect(parent).to have_received(:child_url).with(id)
      end

      it 'returns the result of calling #child_url' do
        expect(subject.url).to eq(:child_url)
      end
    end
  end

  describe '#parent_url' do
    context 'when the UrlReferenceable has a nil parent' do
      let(:parent) { nil }

      # Note that having a nil parent is considered an error in itself.
      # Parentless objects should use Parentless as a null object.
      specify { expect { subject.parent_url }.to raise_error }
    end

    context 'when the UrlReferenceable has a parent' do
      let(:parent) { double(:parent) }
      let(:url) { double(:url) }

      before(:each) do
        allow(parent).to receive(:url).and_return(url)
      end

      it 'calls #parent' do
        expect(subject).to receive(:parent).with(no_args)
        subject.parent_url
      end

      it 'calls #url on the parent' do
        expect(parent).to receive(:url).once.with(no_args)
        subject.parent_url
      end

      it 'returns the result of #url on the parent' do
        expect(subject.parent_url).to eq(url)
        subject.parent_url
      end
    end
  end
end
