require 'spec_helper'
require 'compo'
require 'hash_composite_shared_examples'

RSpec.describe Compo::Composites::Hash do
  it_behaves_like 'a hash composite'
end
