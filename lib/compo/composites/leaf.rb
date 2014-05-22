require 'compo/composites/composite'

module Compo
  module Composites
    # A Composite that cannot have children
    #
    # Add/remove operations on a leaf composite always fail, and #children
    # always returns the empty hash.
    #
    # This is useful for leaf classes that still need to expose the composite
    # API.
    class Leaf
      include Composite

      # Returns the empty hash
      #
      # @api  public
      # @example  Gets the children
      #   comp.children
      #   #=> {}
      #
      # @return [Hash]  The empty hash.
      def children
        {}
      end

      private

      # Fails to add a child into the leaf
      #
      # @api  private
      #
      # @param id [Object]  Ignored.
      # @param child [Object]  Ignored.
      #
      # @return [nil]
      def add!(_, _)
        nil
      end

      # Fails to remove the given child
      #
      # @api  private
      #
      # @param child [Object]  Ignored.
      #
      # @return [nil]
      def remove!(_)
        nil
      end

      # Fails to remove the child with the given ID
      #
      # @api  private
      #
      # @param id [Object]  Ignored.
      #
      # @return [nil]
      def remove_id!(_)
        nil
      end
    end
  end
end
