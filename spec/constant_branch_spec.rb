require 'spec_helper'
require 'compo'
require 'branch_shared_examples'
require 'leaf_composite_shared_examples'

describe Compo::Branches::Constant do
  let(:value) { 3.141592653 }
  subject { Compo::Branches::Constant.new(value) }

  it_behaves_like 'a branch'
  it_behaves_like 'a leaf composite'

  describe '#value' do
    it 'returns the constant value' do
      expect(subject.value).to eq(value)
    end
  end
end
