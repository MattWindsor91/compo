require 'compo/branch'

module Compo
  # A simple implementation of a branch, whose children are stored in an Hash
  #
  # An HashBranch is a composite object that may be moved into other composite
  # objects.  It stores its children as an Hash, and the ID of each child is
  # its hash key.  Inserting and removing items into the HashBranch will not
  # change the IDs of other items, but inserting with an existing key will
  # remove the previous occupant.
  #
  # This is an extension of HashComposite to include the Movable and
  # ParentTracker mixins.
  class HashBranch < HashComposite
    include Branch
  end
end
