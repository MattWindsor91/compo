require 'compo/composites/composite'

module Compo
  module Composites
    # Null implementation of Composite
    #
    # Add/remove operations on NullComposite always fail, and #children always
    # returns the empty hash.
    #
    # This is useful for leaf classes that still need to expose the composite
    # API.
    class Null
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

      # Fails to add a child into the NullComposite
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
