require 'spec_helper'
require 'compo'

describe Compo::UrlFinder do
  subject { Compo::UrlFinder }
  describe '.find' do
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

    shared_examples 'an unsuccessful finding' do
      specify do
        expect { |b| subject.find(root, url, &b) }.to raise_error(
          "Could not find resource: #{url}"
        )
      end
    end

    shared_examples 'an unsuccessful finding with custom error' do
      specify do
        mp = ->(_) { :a }
        expect { |b| subject.find(root, url, missing_proc: mp,  &b) }
          .to yield_with_args(:a)
      end
    end

    context 'when given a correct root but incorrect URL' do
      context 'using the default missing resource handler' do
        context 'when the URL has a leading slash' do
          it_behaves_like 'an unsuccessful finding' do
            let(:url) { '/a/z' }
          end
        end
        context 'when the URL has a trailing slash' do
          it_behaves_like 'an unsuccessful finding' do
            let(:url) { 'a/z/' }
          end
        end
        context 'when the URL has a leading and trailing slash' do
          it_behaves_like 'an unsuccessful finding' do
            let(:url) { '/a/z/' }
          end
        end
        context 'when the URL has neither leading nor trailing slash' do
          it_behaves_like 'an unsuccessful finding' do
            let(:url) { 'a/z' }
          end
        end
      end

      context 'using a custom error handler' do
        context 'when the URL has a leading slash' do
          it_behaves_like 'an unsuccessful finding with custom error' do
            let(:url) { '/d/e/d' }
          end
        end
        context 'when the URL has a trailing slash' do
          it_behaves_like 'an unsuccessful finding with custom error' do
            let(:url) { 'd/e/d/' }
          end
        end
        context 'when the URL has a leading and trailing slash' do
          it_behaves_like 'an unsuccessful finding with custom error' do
            let(:url) { '/d/e/d/' }
          end
        end
        context 'when the URL has neither leading nor trailing slash' do
          it_behaves_like 'an unsuccessful finding with custom error' do
            let(:url) { 'd/e/d' }
          end
        end
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
