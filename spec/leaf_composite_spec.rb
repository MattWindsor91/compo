require 'spec_helper'
require 'compo'
require 'leaf_composite_shared_examples'

RSpec.describe Compo::Composites::Leaf do
  it_behaves_like 'a leaf composite'
end
