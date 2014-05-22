require 'compo/mixins'

module Compo
  module Branches
    # A movable, URL referenceable parent tracker
    #
    # A Branch represents a fully-featured part of a composite object.  This
    # abstract pattern is implemented concretely by Leaf (a Branch with no
    # children), Array (a Branch with a list of numerically identified
    # children), and Hash (a Branch with a hash of key-identified children).
    module Branch
      include Mixins::Movable
      include Mixins::ParentTracker
      include Mixins::UrlReferenceable
    end
  end
end
