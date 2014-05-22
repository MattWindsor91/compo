require 'compo/branches/branch'
require 'compo/composites'

module Compo
  module Branches
    # A simple implementation of a branch, whose children are stored in an Array
    #
    # An array branch is a composite object that may be moved into other
    # composite objects.  It stores its children as an Array, and the ID of each
    # child is its current index in the array.  Inserting and removing items
    # into the branch may change the IDs of items with higher indices in the
    # array.
    class Array < Compo::Composites::Array
      include Branch
    end
  end
end
