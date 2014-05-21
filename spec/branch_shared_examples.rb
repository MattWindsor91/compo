require 'url_referenceable_shared_examples'
require 'movable_shared_examples'

shared_examples 'a branch' do
  it_behaves_like 'a URL referenceable object'
  it_behaves_like 'a movable object'

  describe '#initialize' do
    it 'initialises with a Parentless as parent' do
      expect(subject.parent).to be_a(Compo::Parentless)
    end

    it 'initialises with an ID function returning nil' do
      expect(subject.id).to be_nil
    end
  end

  describe '#url' do
    context 'when the Branch has no parent' do
      it 'returns the empty string' do
        expect(subject.url).to eq('')
      end
    end
    context 'when the Branch is the child of a root' do
      let(:parent) { Compo::HashBranch.new }
      before(:each) { subject.move_to(parent, :id) }

      it 'returns /ID, where ID is the ID of the Leaf' do
        expect(subject.url).to eq('/id')
      end
    end
  end

  describe '#move_to' do
    context 'when the Branch has a parent' do
      context 'when the new parent is nil' do
        let(:parent) { Compo::HashBranch.new }
        before(:each) { subject.move_to(parent, :id) }

        it 'loses its previous parent' do
          expect(subject.move_to(nil, :id).parent).to be_a(Compo::Parentless)
        end

        it 'is no longer a child of its parent' do
          subject.move_to(nil, :id)
          expect(parent.children).to_not include(subject)
        end
      end
    end
  end
end
