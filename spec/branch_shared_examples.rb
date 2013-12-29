require 'url_referenceable_shared_examples'

shared_examples 'a branch' do
  it_behaves_like 'a URL referenceable object'

  describe '#initialize' do
    it 'initialises with a Parentless as parent' do
      expect(subject.parent).to be_a(Compo::Parentless)
    end

    it 'initialises with an ID function returning nil' do
      expect(subject.id).to be_nil
    end
  end
end
