require 'spec_helper'
require 'compo'
require 'branch_shared_examples'
require 'null_composite_shared_examples'

describe Compo::Branches::Leaf do
  it_behaves_like 'a branch'
  it_behaves_like 'a null composite'
end
