require 'spec_helper'
require 'compo'

describe Compo::Leaf do
  describe '#initialize' do
    it 'initialises with no parent' do
      expect(subject.parent).to be_nil
    end

    it 'initialises with an ID function returning nil' do
      expect(subject.id).to be_nil
    end
  end
end
