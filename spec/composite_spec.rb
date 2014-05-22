require 'spec_helper'
require 'compo'
require 'composite_shared_examples'

# Mock implementation of a Composite
class MockComposite
  include Compo::Composites::Composite
end

describe MockComposite do
  before(:each) { allow(subject).to receive(:children).and_return(children) }
  let(:children) { { in_children: child } }
  let(:child) { double(:child) }

  it_behaves_like 'a composite'
  it_behaves_like 'a composite with default #remove!'
  it_behaves_like 'a composite with default #remove_id!'

  #
  # Specifications for Composite's default behaviour.
  #
  describe '#get_child' do
    it 'calls #children' do
      expect(subject).to receive(:children).once
      subject.get_child(:in_children)
    end
  end
end
