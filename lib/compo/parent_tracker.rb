require 'forwardable'

module Compo
  # Basic implementation of parent tracking as a mixin
  #
  # This implements #parent, #update_parent and #remove_parent to track the
  # current parent and ID function as instance variables.  It also implements
  # #parent, and #id in terms of the ID function.
  #
  # Subclasses should call #remove_parent in their #initialize methods, to
  # set the parent and ID function to their default, empty values.
  module ParentTracker
    extend Forwardable

    # Gets this object's current ID
    #
    # @api  public
    # @example  Gets the object's parent while it has none.
    #   parent_tracker.parent
    #   #=> nil
    # @example  Gets the object's parent while it has one.
    #   parent_tracker.parent
    #   #=> :the_current_parent
    #
    # @return [Composite]  The current parent.
    attr_reader :parent

    # Gets this object's current ID
    #
    # @api  public
    # @example  Gets the object's ID while it has no parent.
    #   parent_tracker.id
    #   #=> nil
    # @example  Gets the object's ID while it has a parent.
    #   parent_tracker.id
    #   #=> :the_current_id
    #
    # @return [Object]  The current ID.
    def_delegator :@id_function, :call, :id

    # Updates this object's parent and ID function
    #
    # @api  public
    # @example  Update this Leaf's parent and ID function.
    #   parent_tracker.update_parent(new_parent, new_id_function)
    #
    # @return [void]
    def update_parent(new_parent, new_id_function)
      @parent = new_parent
      @id_function = new_id_function
    end

    # Blanks out this object's parent and ID function
    #
    # @api  public
    # @example  Update this Leaf's parent and ID function.
    #   movable.update_parent(new_parent, new_id_function)
    #
    # @return [void]
    def remove_parent
      update_parent(nil, -> { nil })
    end
  end
end
