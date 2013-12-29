shared_examples 'a URL referenceable object' do
  let(:parent) { nil }
  let(:id) { double(:id) }

  before(:each) do
    allow(subject).to receive(:id).and_return(id)
    allow(subject).to receive(:parent).and_return(parent)
  end

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
        expect(subject).to receive(:id)
        subject.url
      end

      it 'calls #parent' do
        expect(subject).to receive(:parent)
        subject.url
      end

      it 'calls #child_url on the parent with the ID' do
        expect(parent).to receive(:child_url).with(id)
        subject.url
      end

      it 'returns the result of calling #child_url' do
        expect(subject.url).to eq(:child_url)
      end
    end
  end

  describe '#parent_url' do
    context 'when the UrlReferenceable has no parent' do
      let(:parent) { nil }

      specify { expect(subject.parent_url).to be_nil }

      it 'calls #parent' do
        expect(subject).to receive(:parent)
        subject.parent_url
      end
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
