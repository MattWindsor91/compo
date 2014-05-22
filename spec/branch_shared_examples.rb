require 'url_finder_shared_examples'
require 'url_referenceable_shared_examples'
require 'movable_shared_examples'

RSpec.shared_examples 'a branch' do
  it_behaves_like 'a URL referenceable object'
  it_behaves_like 'a movable object'

  describe '#initialize' do
    it 'initialises with a Parentless as parent' do
      expect(subject.parent).to be_a(Compo::Composites::Parentless)
    end

    it 'initialises with an ID function returning nil' do
      expect(subject.id).to be_nil
    end
  end

  shared_context 'the branch has a parent' do
    let(:parent) { Compo::Branches::Hash.new }
    before(:each) { subject.move_to(parent, :id) }
  end

  describe '#url' do
    context 'when the Branch has no parent' do
      it 'returns the empty string' do
        expect(subject.url).to eq('')
      end
    end
    context 'when the Branch is the child of a root' do
      include_context 'the branch has a parent'

      it 'returns /ID, where ID is the ID of the Branch' do
        expect(subject.url).to eq('/id')
      end
    end
  end

  describe '#move_to' do
    context 'when the Branch has a parent' do
      context 'when the new parent is nil' do
        include_context 'the branch has a parent'

        it 'loses its previous parent' do
          expect(subject.move_to(nil, :id).parent).to be_a(
            Compo::Composites::Parentless
          )
        end

        it 'is no longer a child of its parent' do
          subject.move_to(nil, :id)
          expect(parent.children).to_not include(subject)
        end
      end
    end
  end
end

RSpec.shared_examples 'a branch with children' do
  it_behaves_like 'a branch'

  describe '#find_url' do
    it_behaves_like 'a URL finding' do
      let(:target) { Compo::Branches::Leaf.new }

      before(:each) do
        a    = Compo::Branches::Hash.new
        b    = Compo::Branches::Array.new
        d    = Compo::Branches::Leaf.new
        e    = Compo::Branches::Leaf.new
        zero = Compo::Branches::Leaf.new

        a.move_to(subject, initial_ids[0])
        b.move_to(a, 'b')
        zero.move_to(b, 0)
        target.move_to(b, 1)
        d.move_to(subject, initial_ids[1])
        e.move_to(a, 'e')
      end

      let(:correct_url)   { "#{initial_ids[0]}/b/1" }
      let(:incorrect_url) { "#{initial_ids[0]}/z/1" }

      let(:proc) { ->(*args, &b) { subject.find_url(*args, &b) } }
    end
  end
end
