require 'compo/branch'
require 'compo/null_composite'
require 'compo/parent_tracker'

module Compo
  # A simple implementation of a leaf node
  #
  # Leaves have no children, but can be moved to one.  They implement the
  # Composite API, but all additions and removals fail, and the Leaf always
  # reports no children.
  class Leaf < NullComposite
    include Branch
  end
end
