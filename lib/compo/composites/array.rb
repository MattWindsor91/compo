require 'forwardable'
require 'compo/composites/composite'

module Compo
  module Composites
    # Implementation of Composite that stores its children in an Array.
    #
    # IDs for items entering an Array must be numeric, and will change if
    # an item with an ID less than the item in question is deleted or inserted.
    # This means the ID function for objects in an Array may report
    # different values at different times.
    #
    # Adding an object at an occupied ID moves the occupant and those at
    # successive IDs up by one.
    class Array
      include Composite
      extend Forwardable

      # Initialises an array composite
      #
      # @api  public
      # @example  Initializes an array composite.
      #   comp = Compo::Composites::Array.new
      def initialize
        @children = []
      end

      # Returns the array composite's children, as a Hash
      #
      # @api  public
      # @example  Gets the children of an empty array composite.
      #   comp.children
      #   #=> {}
      # @example  Gets the children of a populated array composite.
      #   comp.children
      #   #=> {0: :first, 1: :second}
      #
      # @return [Hash]  The Hash mapping the IDs of children to their values.
      def children
        ::Hash[(0...@children.size).zip(@children)]
      end

      private

      def_delegator :@children, :delete, :remove!
      def_delegator :@children, :delete_at, :remove_id!

      # Inserts a child into the array composite with the given ID
      #
      # You probably want to use #add instead.
      #
      # @api  private
      #
      # @param id [Object]  The ID under which the child is to be added.
      # @param child [Object]  The child to add to the array composite.
      #
      # @return [Object]  The newly added child, or nil if the ID was invalid.
      def add!(id, child)
        valid_id?(id) ? do_insert(id, child) : nil
      end

      # Checks to see if the given ID is valid
      #
      # A valid ID for ArrayComposites is a number between 0 and the current
      # size of the children list.
      #
      # @api  private
      #
      # @param id [Object]  The candidate ID.
      #
      # @return [Boolean]  True if the ID is valid; false if not.
      def valid_id?(id)
        id.is_a?(Numeric) && (0..@children.size).cover?(id)
      end

      # Actually performs the insertion of an item into the array
      #
      # @api  private
      #
      # @param id [Numeric]  The index into the array at which the child is to
      #   be inserted.
      # @param child [Object]  The object to insert into the children array.
      #
      # @return [Object]  The inserted child.
      def do_insert(id, child)
        @children.insert(id, child)
        child
      end

      # Creates an ID function for the given child
      #
      # The returned proc is O(n), as it checks the child array at each call to
      # find the current ID of the child.
      #
      # @api  private
      #
      # @param child [Object]  The child whose ID is to be returned by the proc.
      #
      # @return [Proc]  A proc returning the child's ID.
      def id_function(object)
        proc { @children.index(object) }
      end
    end
  end
end
