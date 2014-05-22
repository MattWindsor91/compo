require 'compo/mixins'

module Compo
  # A movable, URL referenceable parent tracker
  #
  # A Branch represents a fully-featured part of a composite object.  This
  # abstract pattern is implemented concretely by Leaf (a Branch with no
  # children), ArrayBranch (a Branch with a list of numerically identified
  # children), and HashBranch (a Branch with a hash of key-identified children).
  # reports no children.
  #
  #
  module Branch
    include Mixins::Movable
    include Mixins::ParentTracker
    include Mixins::UrlReferenceable
  end
end
