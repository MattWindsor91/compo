require 'spec_helper'
require 'compo'
require 'branch_shared_examples'
require 'leaf_composite_shared_examples'

RSpec.describe Compo::Branches::Leaf do
  it_behaves_like 'a branch'
  it_behaves_like 'a leaf composite'
end
