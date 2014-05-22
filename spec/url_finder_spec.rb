require 'spec_helper'
require 'compo'
require 'url_finder_shared_examples'

describe Compo::Finders::Url do
  subject { Compo::Finders::Url }
  describe '.find' do
    context 'when given a nil root' do
      specify { expect { |b| subject.find(nil, 'a/b/1', &b) }.to raise_error }
    end

    it_behaves_like 'a URL finding' do
      let(:target) { Compo::Branches::Leaf.new }

      let(:root) do
        s    = Compo::Branches::Hash.new
        a    = Compo::Branches::Hash.new
        b    = Compo::Branches::Array.new
        d    = Compo::Branches::Leaf.new
        e    = Compo::Branches::Leaf.new
        zero = Compo::Branches::Leaf.new

        s.add('a', a)
        a.add('b', b)
        b.add(0, zero)
        b.add(1, target)
        s.add('d', d)
        a.add('e', e)
        s
      end

      subject { ->(*args, &b) { Compo::Finders::Url.find(root, *args, &b) } }
    end
  end
end
