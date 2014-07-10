require 'spec_helper'
require 'compo'

RSpec.describe Compo::Finders::Root do
  subject { Compo::Finders::Root }

  it { should < Enumerable }

  describe '.find' do
    context 'when given a root' do
      it 'returns the root' do
        l = Compo::Branches::Leaf.new

        expect { |b| subject.find(l, &b) }.to yield_with_args(l)
      end
    end

    context 'when given a leaf' do
      it 'returns its root' do
        a = Compo::Branches::Hash.new
        b = Compo::Branches::Hash.new
        l = Compo::Branches::Leaf.new

        l.move_to(b, :l)
        b.move_to(a, :b)

        expect { |block| subject.find(l, &block) }.to yield_with_args(a)
      end
    end
  end

  describe '.each' do
    subject { Compo::Finders::Root.new(leaf) }

    context 'when given a root' do
      let(:leaf) { Compo::Branches::Leaf.new }

      it 'returns the root' do
        expect { |block| subject.each(&block) }.to yield_with_args(leaf)
      end
    end

    context 'when given a leaf' do
      let(:root) { Compo::Branches::Hash.new }
      let(:a) { Compo::Branches::Hash.new }
      let(:b) { Compo::Branches::Hash.new }
      let(:c) { Compo::Branches::Hash.new }
      let(:leaf) do
        l = Compo::Branches::Leaf.new

        l.move_to(c,    :l)
        c.move_to(b,    :c)
        b.move_to(a,    :b)
        a.move_to(root, :a)

        l
      end

      it 'returns each item in the path' do
        expect { |b| subject.each(&b) }.to yield_successive_args(
          leaf, c, b, a, root
        )
      end
    end
  end
end
