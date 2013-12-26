require 'forwardable'
require 'compo/composite'

module Compo
  # Implementation of Composite that stores its children in a Hash.
  #
  # IDs for items entering a ListComposite may be any permissible hash.
  #
  # Adding an item at an occupied ID removes the occupant.
  class HashComposite
    include Composite
    extend Forwardable

    def initialize
      @children = {}
    end

    private

    def add!(id, child)
      remove_id(id)
      @children[id] = child
    end

    def_delegator :@children, :delete, :remove_id!
    attr_reader :@children

    def id_function(object)
      id = @children.key(object)
      proc { id }
    end
  end
end
