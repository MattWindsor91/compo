require 'spec_helper'
require 'compo'

describe Compo::ArrayBranch do
  describe '#initialize' do
    it 'initialises with a Parentless as parent' do
      expect(subject.parent).to be_a(Compo::Parentless)
    end

    it 'initialises with an ID function returning nil' do
      expect(subject.id).to be_nil
    end
  end
end
