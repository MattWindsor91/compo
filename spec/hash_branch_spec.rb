require 'spec_helper'
require 'compo'
require 'branch_shared_examples'
require 'hash_composite_shared_examples'

describe Compo::Branches::Hash do
  it_behaves_like 'a branch with children' do
    let(:initial_ids) { ['a', 'b'] }
  end
  it_behaves_like 'a hash composite'
end
