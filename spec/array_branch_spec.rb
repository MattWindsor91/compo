require 'spec_helper'
require 'compo'
require 'array_composite_shared_examples'
require 'branch_shared_examples'

describe Compo::Branches::Array do
  it_behaves_like 'a branch'
  it_behaves_like 'an array composite'
end
