require 'spec_helper'
require 'compo'

describe Compo::UrlFinder do
  subject { Compo::UrlFinder }
  describe '.find' do
    let(:target) { Compo::Leaf.new }

    let(:root) do
      s    = Compo::HashBranch.new
      a    = Compo::HashBranch.new
      b    = Compo::ArrayBranch.new
      d    = Compo::Leaf.new
      e    = Compo::Leaf.new
      zero = Compo::Leaf.new

      s.add('a', a)
      a.add('b', b)
      b.add(0, zero)
      b.add(1, target)
      s.add('d', d)
      a.add('e', e)
      s
    end

    context 'when given a nil root' do
      specify { expect { |b| subject.find(nil, 'a/b/1', &b) }.to raise_error }
    end

    context 'when given a nil URL' do
      specify { expect { |b| subject.find(root, nil, &b) }.to raise_error }
    end

    shared_examples 'a successful finding' do
      it 'returns the correct resource' do
        expect { |b| subject.find(root, url, &b) }.to yield_with_args(target)
      end
    end

    context 'when given a correct root and URL' do
      context 'when the URL leads to a resource' do
        context 'when the URL has a leading slash' do
          it_behaves_like 'a successful finding' do
            let(:url) { '/a/b/1' }
          end
        end
        context 'when the URL has a trailing slash' do
          it_behaves_like 'a successful finding' do
            let(:url) { 'a/b/1/' }
          end
        end
        context 'when the URL has a leading and trailing slash' do
          it_behaves_like 'a successful finding' do
            let(:url) { '/a/b/1/' }
          end
        end
        context 'when the URL has neither leading nor trailing slash' do
          it_behaves_like 'a successful finding' do
            let(:url) { 'a/b/1' }
          end
        end
      end
    end
  end
end
