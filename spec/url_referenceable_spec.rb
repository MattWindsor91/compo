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
    end
  end

  describe '#parent_url' do
    context 'when the UrlReferenceable has no parent' do
      let(:parent) { nil }

      specify { expect(subject.parent_url).to be_nil }

      it 'calls #parent' do
        expect(subject).to receive(:parent).once
      end
    end

    context 'when the UrlReferenceable has a parent' do
      let(:parent) { double(:parent) }

      it 'calls #parent' do
        expect(subject).to receive(:parent).once
      end
    end
  end
end
