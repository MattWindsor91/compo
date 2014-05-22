require 'forwardable'
require 'compo/composites/composite'

module Compo
  module Composites
    # Implementation of Composite that stores its children in a Hash.
    #
    # IDs for items entering a ListComposite may be any permissible hash.
    #
    # Adding an item at an occupied ID removes the occupant.
    class Hash
      include Composite
      extend Forwardable

      # Initialises a hash composite
      #
      # @api  public
      # @example  Initializes a hash composite.
      #   comp = Compo::Composites::Hash.new
      def initialize
        @children = {}
      end

      # Returns the hash composite's children, as a Hash
      #
      # @api  public
      # @example  Gets the children of an empty hash composite.
      #   comp.children
      #   #=> {}
      # @example  Gets the children of a populated hash composite.
      #   comp.children
      #   #=> {foo: 3, bar: 5}
      #
      # @return [Hash]  The Hash mapping the IDs of children to their values.
      attr_reader :children

      private

      # Inserts a child into the hash composite with the given ID
      #
      # You probably want to use #add instead.
      #
      # @api  private
      #
      # @param id [Object]  The ID under which the child is to be added.
      # @param child [Object]  The child to add to the hash composite.
      #
      # @return [Object]  The newly added child.
      def add!(id, child)
        remove_id(id)
        @children[id] = child
      end

      def_delegator :@children, :delete, :remove_id!

      # Creates an ID function for the given child
      #
      # The returned proc is O(1), as it stores the ID assigned to the child at
      # calling time under the assumption that it will not change until removal.
      #
      # @api  private
      #
      # @param child [Object]  The child whose ID is to be returned by the proc.
      #
      # @return [Proc]  A proc returning the child's ID.
      def id_function(child)
        id = @children.key(child)
        proc { id }
      end
    end
  end
end
