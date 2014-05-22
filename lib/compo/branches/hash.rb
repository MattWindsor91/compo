require 'compo/branches/branch'
require 'compo/composites'

module Compo
  module Branches
    # A simple implementation of a branch, whose children are stored in an Hash
    #
    # A hash branch is a composite object that may be moved into other composite
    # objects.  It stores its children as an Hash, and the ID of each child is
    # its hash key.  Inserting and removing items into the branch will not
    # change the IDs of other items, but inserting with an existing key will
    # remove the previous occupant.
    class Hash < Compo::Composites::Hash
      include Branch
    end
  end
end
