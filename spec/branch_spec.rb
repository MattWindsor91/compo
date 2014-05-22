require 'spec_helper'
require 'compo'
require 'branch_shared_examples'

# Mock implementation of a Branch
class MockBranch
  include Compo::Branches::Branch
end

describe MockBranch do
  it_behaves_like 'a branch'
end
