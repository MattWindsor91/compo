require 'spec_helper'
require 'compo'
require 'null_composite_shared_examples'

describe Compo::Composites::Null do
  it_behaves_like 'a null composite'
end
