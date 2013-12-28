require 'spec_helper'
require 'compo'

# Mock implementation of UrlReferenceable.
class MockUrlReferenceable
  include Compo::UrlReferenceable
end

describe MockUrlReferenceable do
  describe '#url' do
    context 'when the UrlReferenceable has no parent' do
    end

    context 'when the UrlReferenceable has a parent' do
    end
  end

  describe '#parent_url' do
    context 'when the UrlReferenceable has no parent' do
    end

    context 'when the UrlReferenceable has a parent' do
    end
  end
end
