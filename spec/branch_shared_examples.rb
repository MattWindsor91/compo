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
    context 'when the Leaf has no parent' do
      it 'returns the empty string' do
        expect(subject.url).to eq('')
      end
    end
    context 'when the Leaf is the child of a root' do
      let(:parent) { Compo::HashBranch.new }
      before(:each) { subject.move_to(parent, :id) }

      it 'returns /ID, where ID is the ID of the Leaf' do
        expect(subject.url).to eq('/id')
      end
    end
  end
end
