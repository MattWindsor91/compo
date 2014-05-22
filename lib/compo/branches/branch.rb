require 'compo/mixins'
require 'compo/finders'

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

      # Traverses this Branch and its children following a URL
      #
      # See Compo::Finders::Url for more information about what this means.
      # This is a convenience wrapper over that method object, and is equivalent
      # to 'Compo::Finders::Url.find(self, *args, &block)'.
      #
      # @api  public
      # @example  From this Branch, find the item at 'a/b/1'.
      #   branch.on_url('a/b/1') { |item| p item }
      #
      # @yieldparam [Object]  The found resource.
      #
      # @return [Object]  Whatever is returned by the block.
      def find_url(*args, &block)
        Compo::Finders::Url.find(self, *args, &block)
      end
    end
  end
end
