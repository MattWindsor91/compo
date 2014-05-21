require 'compo/movable'
require 'compo/parent_tracker'
require 'compo/url_referenceable'

module Compo
  # A movable, URL referenceable parent tracker
  #
  # A Branch represents a fully-featured part of a composite object.  This
  # abstract pattern is implemented concretely by Leaf (a Branch with no
  # children), ArrayBranch (a Branch with a list of numerically identified
  # children), and HashBranch (a Branch with a hash of key-identified children).
  # reports no children.
  module Branch
    include Movable
    include ParentTracker
    include UrlReferenceable
  end
end
