module Compo
  # Mixin for objects that can contain other objects
  #
  # Objects implementing this interface should implement add!, remove! or
  # remove_id!, and id_function:
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
      add!(id, child).tap(&method(:assign_parent))
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
      remove!(child).tap(&method(:remove_parent))
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
      remove_id!(id).tap(&method(:remove_parent))
    end

    def_delegator :children, :each

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
    def assign_parent(child)
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
    def remove_parent(child)
      child.remove_parent unless child.nil?
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
