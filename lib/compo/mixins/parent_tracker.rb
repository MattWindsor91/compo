require 'forwardable'
require 'compo/composites/parentless'

module Compo
  module Mixins
    # Basic implementation of parent tracking as a mixin
    #
    # Adding this to a Composite allows the composite to be aware of its current
    # parent.
    #
    # This implements #parent, #update_parent and #remove_parent to track the
    # current parent and ID function as instance variables.  It also implements
    # #parent, and #id in terms of the ID function.
    module ParentTracker
      extend Forwardable

      # Initialises the ParentTracker
      #
      # This constructor sets the tracker up so it initially has an instance of
      # Parentless as its 'parent'.
      #
      # @api  semipublic
      # @example  Creates a new ParentTracker.
      #   ParentTracker.new
      #
      # @return [Void]
      def initialize
        super()
        Compo::Composites::Parentless.for(self)
      end

      # Gets whether this ParentTracker is the root of its composite tree.
      #
      # This is equivalent to the ParentTracker having no parent.
      #
      # @api  public
      # @example  Checks if a ParentTracker with no parent is a root.
      #   orphan.root?
      #   #=> true
      # @example  Checks if a ParentTracker with a parent is a root.
      #   parented.root?
      #   #=> false
      def root?
        parent.is_a?(Compo::Composites::Parentless)
      end

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
      def_delegator :@id_proc, :call, :id

      # Updates this object's parent and ID function
      #
      # @api  public
      # @example  Update this Leaf's parent and ID function.
      #   parent_tracker.update_parent(new_parent, new_id_function)
      #
      # @return [void]
      def update_parent(new_parent, new_id_proc)
        fail 'Parent cannot be nil: use #remove_parent.' if new_parent.nil?
        fail 'ID function cannot be nil: use -> { nil }.' if new_id_proc.nil?

        @parent = new_parent
        @id_proc = new_id_proc
      end
    end
  end
end
