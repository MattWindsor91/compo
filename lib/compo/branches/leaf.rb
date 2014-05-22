require 'compo/branches/branch'
require 'compo/composites'

module Compo
  module Branches
    # A simple implementation of a leaf node
    #
    # Leaves have no children, but can be moved to one.  They implement the
    # Composite API, but all additions and removals fail, and the Leaf always
    # reports no children.
    class Leaf < Compo::Composites::Null
      include Branch
    end
  end
end
