require 'spec_helper'
require 'compo'

class MockComposite
  include Compo::Composite
end

describe MockComposite do
  let(:id) { double(:id) }
  let(:child) { double(:child) }

  describe '#add' do
    before(:each) { allow(subject).to receive(:add!) }

    it 'calls #add! with the ID and child given' do
      expect(subject).to receive(:add!).once.with(id, child)
      subject.add(id, child)
    end
  end
end
