require 'spec_helper'
require 'compo'

# Mock implementation of UrlReferenceable.
class MockUrlReferenceable
  include Compo::UrlReferenceable
end

describe MockUrlReferenceable do
  describe '#url' do
  end

  describe '#parent_url' do
  end
end
