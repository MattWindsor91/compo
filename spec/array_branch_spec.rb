require 'spec_helper'
require 'compo'
require 'array_composite_shared_examples'
require 'branch_shared_examples'

RSpec.describe Compo::Branches::Array do
  it_behaves_like 'a branch with children' do
    let(:initial_ids) { [0, 1] }
  end
  it_behaves_like 'an array composite'
end
