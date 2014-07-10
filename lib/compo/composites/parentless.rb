require 'compo/composites/composite'

module Compo
  module Composites
    # A Composite that represents the non-existent parent of an orphan
    #
    # Parentless is the parent assigned when an object is removed from a
    # Composite, and should be the default parent of an object that can be
    # added to one.  It exists to make some operations easier, such as URL
    # creation.
    class Parentless
      include Composite

      # Creates a new instance of Parentless and adds an item to it
      #
      # This effectively removes the item's parent.
      #
      # If this method is passed nil, then nothing happens.
      #
      # @api  public
      # @example  Makes a new Parentless for an item.
      #   Parentless.for(item)
      # @example  Does nothing.
      #   Parentless.for(nil)
      #
      # @param item [Object] The item to be reparented to a Parentless.
      #
      # @return [void]
      def self.for(item)
        new.add(nil, item) unless item.nil?
      end

      # 'Removes' a child from this Parentless
      #
      # This always succeeds, and never triggers any other action.
      #
      # @api  public
      # @example  'Removes' a child.
      #   parentless.remove(child)
      #
      # @param child [Object]  The child to 'remove' from this Parentless.
      #
      # @return [Object]  The child.
      def remove(child)
        child
      end

      # Returns the empty hash
      #
      # @api  public
      # @example  Gets the children
      #   parentless.children
      #   #=> {}
      #
      # @return [Hash]  The empty hash.
      def children
        {}
      end

      # Returns the URL of this Parentless
      #
      # This is always the empty string.
      #
      # @api  public
      # @example  Gets the URL of a Parentless
      #   parentless.url
      #   #=> ''
      #
      # @return [Hash]  The empty string.
      def url
        ''
      end

      # Returns the parent of this Parentless
      #
      # This is always the same Parentless, for convenience's sake.
      # Technically, as a null object, Parentless has no parent.
      #
      # @api public
      # @example  Gets the 'parent' of a Parentless.
      #   parentless.parent
      #
      # @return [self]
      def parent
        self
      end

      protected

      # 'Adds' a child to this Parentless
      #
      # This always succeeds.
      #
      # @api private
      #
      # @param id [Object]  Ignored.
      # @param child [Object]  The object to 'add' to this Parentless.
      #
      # @return [Object]  The child.
      def add!(_, child)
        child
      end

      # Creates an ID function for the given child
      #
      # The returned proc is O(1), and always returns nil.
      #
      # @api  private
      #
      # @param child [Object]  The child whose ID is to be returned by the proc.
      #
      # @return [Proc]  A proc returning nil.
      def id_function(_)
        -> { nil }
      end
    end
  end
end
