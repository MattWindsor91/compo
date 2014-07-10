RSpec.shared_examples 'a URL referenceable object' do
  let(:parent) { nil }
  let(:id) { :id }
  let(:parent_id) { :parent_id }

  before(:each) do
    allow(subject).to receive_messages(
      id: id,
      parent: parent,
      root?: false
    )
  end

  describe '#url' do
    context 'when the UrlReferenceable has no parent' do
      specify { expect { subject.url }.to raise_error }
    end

    context 'when the UrlReferenceable has a parent' do
      let(:parent) { double(:parent) }
      before(:each) do
        allow(parent).to receive_messages(
          parent: Compo::Composites::Parentless.new,
          root?: true
        )
      end

      it 'calls #id' do
        subject.url
        expect(subject).to have_received(:id)
      end

      it 'calls #parent' do
        subject.url
        expect(subject).to have_received(:parent)
      end

      it 'returns /id' do
        expect(subject.url).to eq('/id')
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
