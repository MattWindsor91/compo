require 'spec_helper'
require 'compo'
require 'branch_shared_examples'

describe Compo::Leaf do
  it_behaves_like 'a branch'

  describe '#url' do
    context 'when the Leaf has no parent' do
      it 'returns the empty string' do
        expect(subject.url).to eq('')
      end
    end
    context 'when the Leaf is the child of a root' do
      let(:parent) { Compo::HashBranch.new }
      before(:each) { subject.move_to(parent, :id) }

      it 'returns /ID, where ID is the ID of the Leaf' do
        expect(subject.url).to eq('/id')
      end
    end
  end
end
