require 'spec_helper'
require 'compo'
require 'movable_shared_examples'

# Mock implementation of a Movable
class MockMovable
  include Compo::Mixins::Movable
end

RSpec.describe MockMovable do
  it_behaves_like 'a movable object'
end
