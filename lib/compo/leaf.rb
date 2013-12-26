module Compo
  # A simple implementation of a leaf
  #
  # Leaves have no children, but can be moved to one.
  class Leaf < NullComposite
    include Movable
    include ParentTracker

    # Initialises the Leaf
    #
    # @api  public
    # @example  Creates a new Leaf.
    #   leaf.new
    def initialize
      remove_parent
    end
  end
end
