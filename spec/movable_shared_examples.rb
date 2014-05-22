require 'compo'

shared_examples 'a normal call to #move_to' do
  it 'returns itself' do
    expect(subject.move_to(to, :test)).to eq(subject)
  end

  it 'calls #parent' do
    expect(subject).to receive(:parent)
    subject.move_to(to, :test)
  end
end

shared_examples 'a removal from the old parent' do
  it 'calls #remove on the old parent with the Movable' do
    expect(from).to receive(:remove).once.with(subject)
    subject.move_to(to, :test)
  end
end

shared_examples 'an addition to the new parent' do
  it 'calls #add on the new parent with the ID and Movable' do
    expect(to).to_not be_nil
    expect(to).to receive(:add).once.with(:test, subject)
    subject.move_to(to, :test)
  end
end

shared_examples 'a movable object' do
  let(:old_parent)    { double(:old_parent) }
  let(:new_parent)    { double(:new_parent) }
  let(:remove_result) { subject }
  let(:add_result)    { subject }

  before(:each) do
    allow(subject).to receive(:parent).and_return(old_parent)
    allow(old_parent).to receive(:remove).and_return(remove_result)

    unless new_parent.nil?
      allow(new_parent).to receive(:add).and_return(add_result)
    end
  end

  describe '#move_to' do
    context 'when the receiving parent is nil' do
      let(:new_parent) { nil }

      context 'and the Movable has no parent' do
        let(:old_parent) { Compo::Composites::Parentless.new }

        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end
      end

      context 'and the Movable has a parent' do
        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end

        it_behaves_like 'a removal from the old parent' do
          let(:to) { new_parent }
          let(:from) { old_parent }
        end
      end
    end

    context 'when the receiving parent refuses to add the Movable' do
      let(:add_result) { nil }

      context 'and the Movable has no parent' do
        let(:old_parent) { Compo::Composites::Parentless.new }

        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end

        it_behaves_like 'an addition to the new parent' do
          let(:to) { new_parent }
        end
      end

      context 'and the Movable has a parent that refuses to remove it' do
        let(:remove_result) { nil }

        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end

        it_behaves_like 'a removal from the old parent' do
          let(:to) { new_parent }
          let(:from) { old_parent }
        end
      end

      context 'and the Movable has a parent that allows it to be removed' do
        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end

        it_behaves_like 'a removal from the old parent' do
          let(:to) { new_parent }
          let(:from) { old_parent }
        end

        it_behaves_like 'an addition to the new parent' do
          let(:to) { new_parent }
        end
      end
    end

    context 'when the receiving parent allows the Movable to be added' do
      context 'and the Movable has no parent' do
        let(:old_parent) { Compo::Composites::Parentless.new }

        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end

        it_behaves_like 'an addition to the new parent' do
          let(:to) { new_parent }
        end
      end

      context 'and the Movable has a parent that refuses to remove it' do
        let(:remove_result) { nil }

        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end

        it_behaves_like 'a removal from the old parent' do
          let(:to) { new_parent }
          let(:from) { old_parent }
        end
      end

      context 'and the Movable has a parent that allows it to be removed' do
        it_behaves_like 'a normal call to #move_to' do
          let(:to) { new_parent }
        end

        it_behaves_like 'a removal from the old parent' do
          let(:to) { new_parent }
          let(:from) { old_parent }
        end

        it_behaves_like 'an addition to the new parent' do
          let(:to) { new_parent }
        end
      end
    end
  end
end
