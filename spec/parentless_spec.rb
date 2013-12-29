require 'spec_helper'
require 'compo'

describe Compo::Parentless do
  let(:child) { double(:child) }

  describe '#add!' do
    it 'returns the given child exactly' do
      expect(subject.add!(:id, child)).to be(child)
    end
  end

  describe '#remove!' do
    it 'returns the given child exactly' do
      expect(subject.remove!(child)).to be(child)
    end
  end

  describe '#children' do
    specify { expect(subject.children).to eq({}) }
  end

  describe '#url' do
    specify { expect(subject.url).to eq('') }
  end

  describe '#child_url' do
    specify { expect(subject.child_url(:id)).to eq('') }
  end

  describe '#parent' do
    it 'returns the exact same Parentless object' do
      expect(subject.parent).to be(subject)
    end
  end
end
