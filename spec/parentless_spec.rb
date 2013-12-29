require 'spec_helper'
require 'compo'

describe Compo::Parentless do
  describe '#children' do
    specify { expect(subject.children).to eq({}) }
  end

  describe '#url' do
    specify { expect(subject.url).to eq('') }
  end

  describe '#child_url' do
    specify { expect(subject.child_url(:id)).to eq('') }
  end
end
