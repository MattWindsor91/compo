require 'forwardable'
require 'compo/composite'

module Compo
  # Implementation of Composite that stores its children in an Array.
  #
  # IDs for items entering a ListComposite must be numeric, and will change if
  # an item with an ID less than the item in question is deleted or inserted.
  # This means the ID function for objects in a ListComposite may report
  # different values at different times.
  #
  # Adding an object at an occupied ID moves the occupant and those at
  # successive IDs up by one.
  class ArrayComposite
    include Composite
    extend Forwardable

    def initialize
      @children = []
    end

    def children
      Hash[(0...@children.size).zip(@children)]
    end

    private

    def_delegator :@children, :delete, :remove!
    def_delegator :@children, :delete_at, :remove_id!

    def add!(id, child)
      can_insert?(id) ? do_insert(id, child) : nil
    end

    def can_insert?(id)
      id.is_a?(Numeric) && (0..@children.size).cover?(id)
    end

    def do_insert(id, child)
      @children.insert(id, child)
      child
    end

    def id_function(object)
      proc { @children.index(object) }
    end
  end
end
