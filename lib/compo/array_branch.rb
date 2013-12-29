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
  class ArrayBranch < ArrayComposite
    include Movable
    include ParentTracker
    include UrlReferenceable

    # Initialises the ArrayBranch
    #
    # The ArrayBranch is created with no children, no parent, and no ID.
    #
    # @api  public
    # @example  Creates a new ArrayBranch.
    #   branch = ArrayBranch.new
    def initialize
      super()
      remove_parent
    end
  end
end
