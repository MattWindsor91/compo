require 'compo'

shared_examples 'a movable object' do
  let(:old_parent) { double(:old_parent) }
  let(:new_parent) { double(:new_parent) }

  describe '#move_to' do
    context 'when the receiving parent is nil' do
      context 'and the Movable has no parent' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(Compo::Parentless.new)
        end

        it 'returns itself' do
          expect(subject.move_to(nil, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(nil, :test)
        end
      end

      context 'and the Movable has a parent' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(old_parent)
          allow(old_parent).to receive(:remove)
        end

        it 'returns itself' do
          expect(subject.move_to(nil, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(nil, :test)
        end

        it 'calls #remove on the old parent with the Movable' do
          expect(old_parent).to receive(:remove).once.with(subject)
          subject.move_to(nil, :test)
        end
      end
    end

    context 'when the receiving parent refuses to add the Movable' do
      before(:each) do
        allow(new_parent).to receive(:add).and_return(nil)
      end

      context 'and the Movable has no parent' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(Compo::Parentless.new)
        end

        it 'returns itself' do
          expect(subject.move_to(new_parent, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(new_parent, :test)
        end

        it 'calls #add on the new parent with the ID and Movable' do
          expect(new_parent).to receive(:add).once.with(:test, subject)
          subject.move_to(new_parent, :test)
        end
      end

      context 'and the Movable has a parent that refuses to remove it' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(old_parent)
          allow(old_parent).to receive(:remove).and_return(nil)
        end

        it 'returns itself' do
          expect(subject.move_to(new_parent, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(new_parent, :test)
        end

        it 'calls #remove on the old parent with the Movable' do
          expect(old_parent).to receive(:remove).once.with(subject)
          subject.move_to(new_parent, :test)
        end
      end

      context 'and the Movable has a parent that allows it to be removed' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(old_parent)
          allow(old_parent).to receive(:remove).and_return(subject)
          allow(new_parent).to receive(:add)
        end

        it 'returns itself' do
          expect(subject.move_to(new_parent, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(new_parent, :test)
        end

        it 'calls #remove on the old parent with the Movable' do
          expect(old_parent).to receive(:remove).once.with(subject)
          subject.move_to(new_parent, :test)
        end

        it 'calls #add on the new parent with the ID and Movable' do
          expect(new_parent).to receive(:add).once.with(:test, subject)
          subject.move_to(new_parent, :test)
        end
      end
    end

    context 'when the receiving parent allows the Movable to be added' do
      before(:each) do
        allow(new_parent).to receive(:add).and_return(subject)
      end

      context 'and the Movable has no parent' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(Compo::Parentless.new)
        end

        it 'returns itself' do
          expect(subject.move_to(new_parent, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(new_parent, :test)
        end

        it 'calls #add on the new parent with the ID and Movable' do
          expect(new_parent).to receive(:add).with(:test_id, subject)

          subject.move_to(new_parent, :test_id)
        end
      end

      context 'and the Movable has a parent that refuses to remove it' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(old_parent)
          allow(old_parent).to receive(:remove).and_return(nil)
        end

        it 'returns itself' do
          expect(subject.move_to(new_parent, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(new_parent, :test)
        end

        it 'calls #remove on the old parent with the Movable' do
          expect(old_parent).to receive(:remove).once.with(subject)
          subject.move_to(new_parent, :test)
        end
      end

      context 'and the Movable has a parent that allows it to be removed' do
        before(:each) do
          allow(subject).to receive(:parent).and_return(old_parent)
          allow(old_parent).to receive(:remove).and_return(subject)
          allow(new_parent).to receive(:add)
        end

        it 'returns itself' do
          expect(subject.move_to(new_parent, :test)).to eq(subject)
        end

        it 'calls #parent' do
          expect(subject).to receive(:parent)
          subject.move_to(new_parent, :test)
        end

        it 'calls #remove on the old parent with the Movable' do
          expect(old_parent).to receive(:remove).once.with(subject)
          subject.move_to(new_parent, :test)
        end

        it 'calls #add on the new parent with the ID and Movable' do
          expect(new_parent).to receive(:add).once.with(:test, subject)
          subject.move_to(new_parent, :test)
        end
      end
    end
  end
end
