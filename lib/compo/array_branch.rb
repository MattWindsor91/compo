require 'compo/branch'
require 'compo/composites'

module Compo
  # A simple implementation of a branch, whose children are stored in an Array
  #
  # An ArrayBranch is a composite object that may be moved into other composite
  # objects.  It stores its children as an Array, and the ID of each child is
  # its current index in the array.  Inserting and removing items into the
  # ArrayBranch may change the IDs of items with higher indices in the array.
  #
  # This is an extension of ArrayComposite to include the Movable and
  # ParentTracker mixins.
  class ArrayBranch < Compo::Composites::Array
    include Branch
  end
end
