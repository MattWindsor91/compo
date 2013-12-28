require 'spec_helper'
require 'compo'

# Mock implementation of UrlReferenceable.
class MockUrlReferenceable
  include Compo::UrlReferenceable
end

describe MockUrlReferenceable
end
