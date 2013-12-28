require 'spec_helper'
require 'compo'

# Mock implementation of UrlReferenceable.
class MockUrlReferenceable
  include Compo::UrlReferenceable
end

describe MockUrlReferenceable do
  before(:each) { allow(subject).to receive(:parent).and_return(parent) }

  describe '#url' do
    context 'when the UrlReferenceable has no parent' do
      let(:parent) { nil }

      it 'returns the empty string' do
        expect(subject.url).to eq('')
      end
    end

    context 'when the UrlReferenceable has a parent' do
      let(:parent) { double(:parent) }
      before(:each) { allow(subject).to receive(:id).and_return('id') }

      it 'calls #id' do
        expect(subject).to receive(:id)
        subject.url
      end

      it 'returns the joining of the parent URL and ID with a slash' do
        allow(subject).to receive(:parent_url).and_return('dog/goes')

        expect(subject.url).to eq('dog/goes/id')
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
