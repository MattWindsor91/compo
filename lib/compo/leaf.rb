require 'compo/movable'
require 'compo/null_composite'
require 'compo/parent_tracker'

module Compo
  # A simple implementation of a leaf node
  #
  # Leaves have no children, but can be moved to one.  They implement the
  # Composite API, but all additions and removals fail, and the Leaf always
  # reports no children.
  class Leaf < NullComposite
    include Movable
    include ParentTracker

    # Initialises the Leaf
    #
    # The Leaf is created with no children, no parent, and no ID.
    #
    # @api  public
    # @example  Creates a new Leaf.
    #   leaf = Leaf.new
    def initialize
      remove_parent
    end
  end
end
