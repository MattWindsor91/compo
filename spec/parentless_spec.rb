require 'spec_helper'
require 'compo'

RSpec.describe Compo::Composites::Parentless do
  let(:child) { double(:child) }

  describe '#add' do
    before(:each) { allow(child).to receive(:update_parent) }

    it 'returns the given child exactly' do
      expect(subject.add(:id, child)).to be(child)
    end

    it 'calls #update_parent on the child with a Parentless' do
      subject.add(:id, child)

      expect(child).to have_received(:update_parent).once.with(
        a_kind_of(Compo::Composites::Parentless),
        anything
      )
    end

    it 'calls #update_parent on the child with a nil-returning ID proc' do
      subject.add(:id, child)
      expect(child).to have_received(:update_parent).once.with(
        anything,
        an_object_satisfying { |idp| idp.call.nil? }
      )
    end
  end

  describe '#remove' do
    it 'returns the given child exactly' do
      expect(subject.remove(child)).to be(child)
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
