require 'spec_helper'
require 'compo'
require 'branch_shared_examples'
require 'hash_composite_shared_examples'

describe Compo::HashBranch do
  it_behaves_like 'a branch'
  it_behaves_like 'a hash composite'
end
