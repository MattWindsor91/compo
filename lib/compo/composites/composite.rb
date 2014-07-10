require 'forwardable'

module Compo
  module Composites
    # Mixin for objects that can contain other objects
    #
    # Objects implementing this interface should implement add!, remove! or
    # remove_id!, and id_function.
    #
    # add!        - Given a desired ID and child, adds the child to the children
    #               of this object; returns the child if successful, nil
    #               otherwise.
    # remove!     - Given a child, removes and returns it from the children; if
    #               not provided, this is implemented in terms of remove_id!.
    # remove_id!  - Given an ID, removes and returns the child with this ID from
    #               the children; if not provided, this is implemented in terms
    #               of remove!.
    # children    - Returns the children, as a Hash mapping from current IDs to
    #               their child values.
    # id_function - Given a newly inserted child, returns a proc that will
    #               always return the child's current ID so long as it is part
    #               of the Composite.
    module Composite
      extend Forwardable
      include Enumerable

      # Adds a child to this Composite
      #
      # @api  public
      # @example  Adds a child with intended id 3.
      #   composite.add_child(3, leaf)
      #
      # @param id  [Object]  The intended ID of the child in this Composite.
      #   The actual ID may not be the same as this; consult the proc supplied
      #   to the child via #update_parent.
      # @param child [Object]  The child to add to this Composite.
      #
      # @return [Object]  The added child if successful; nil otherwise.
      def add(id, child)
        add!(id, child).tap(&method(:assign_parent_to))
      end

      # Removes a child from this Composite directly
      #
      # This method can fail (for example, if the child does not exist in the
      # Composite).
      #
      # @api  public
      # @example  Removes a child.
      #   composite.remove(child)
      #
      # @param child [Object]  The child to remove from this object.
      #
      # @return [Object]  The removed child if successful; nil otherwise.
      def remove(child)
        remove!(child).tap(&method(:remove_parent_of))
      end

      # Removes a child from this Composite, given its ID
      #
      # This method can fail (for example, if the ID does not exist in the
      # Composite).
      #
      # @api  public
      # @example  Removes the child with ID :foo.
      #   composite.remove_id(:foo)
      #
      # @param id  The ID of the child to remove from this object.
      #
      # @return [Object]  The removed child if successful; nil otherwise.
      def remove_id(id)
        remove_id!(id).tap(&method(:remove_parent_of))
      end

      # Gets the child in this Composite with the given ID
      #
      # The ID is compared directly against the IDs of the children of this
      # composite.  To use a predicate to find an ID, use #get_child_such_that.
      #
      # @api  public
      # @example  Gets the child with ID :in, if children is {in: 3}.
      #   composite.get_child(:in)
      #   #=> 3
      # @example  Fails to get the child with ID :out, if children is {in: 3}.
      #   composite.get_child(:out)
      #   #=> nil
      # @example Fails to get the child with ID '1', if children is {1 => 3}.
      #   composite.get_child('1')
      #   #=> nil
      #
      # @param id  [Object]  The ID of the child to get from this Composite.
      #
      # @return [Object]  The child if successful; nil otherwise.
      def get_child(id)
        children[id]
      end

      # Gets the child in this Composite whose ID matches a given predicate
      #
      # If multiple children match this predicate, the result is the first child
      # in the hash.
      #
      # @api  public
      # @example  Gets the child with ID :in, if children is {in: 3}.
      #   composite.get_child_such_that { |x| x == :in }
      #   #=> 3
      # @example  Fails to get the child with ID :out, if children is {in: 3}.
      #   composite.get_child_such_that { |x| x == :out }
      #   #=> nil
      # @example Get the child with an ID whose string form is '1', if children
      #   is {1 => 3}.
      #   composite.get_child_such_that { |x| x.to_s == '3' }
      #   #=> 3
      #
      # @yieldparam id  [Object]  An ID to check against the predicate.
      #
      # @return [Object]  The child if successful; nil otherwise.
      def get_child_such_that(&block)
        child = children.each.find { |k, _| block.call(k) }
        (_, value) = child unless child.nil?
        value
      end

      def_delegator :children, :each

      # Performs an action on this node, if it is an actual Composite node
      #
      # By default, this does indeed run the block provided, and returns the
      # block's result.  Composites that do not represent proper nodes (for
      # example, Parentless) may override this to ignore the block and return
      # nil.
      #
      # @api public
      # @example  Performs an action on this Parentless.
      #   parentless.on_node { |n| 3 }
      #   #=> 3
      # @return [false]
      def on_node
        yield self
      end

      protected

      # Assigns this object to a child as its parent
      #
      # This also updates its ID function to point to the child's ID under this
      # parent.
      #
      # @api  private
      #
      # @param child [Object]  The child whose parent assignment is being set.
      #
      # @return [void]
      def assign_parent_to(child)
        child.update_parent(self, id_function(child)) unless child.nil?
      end

      # Removes a child's parent assignment
      #
      # This also clears its ID function.
      #
      # @api  private
      #
      # @param child [Object]  The child whose parent assignment is being set.
      #
      # @return [void]
      def remove_parent_of(child)
        Parentless.for(child)
      end

      # Default implementation of #remove! in terms of #remove_id!
      #
      # Either this or #remove_id! must be overridden by the implementing class.
      #
      # @api  private
      #
      # @param child [Object]  The child to remove from this object.
      #
      # @return [void]
      def remove!(child)
        remove_id!(children.key(child))
      end

      # Default implementation of #remove_id! in terms of #remove!
      #
      # Either this or #remove! must be overridden by the implementing class.
      #
      # @api  private
      #
      # @param id [Object]  The current ID of the child to remove from this
      #   object.
      #
      # @return [void]
      def remove_id!(id)
        remove!(get_child(id))
      end
    end
  end
end
