require 'compo'

module Compo
  # A Composite that represents the non-existent parent of an orphan
  #
  # Parentless is the parent assigned when an object is removed from a
  # Composite, and
  class Parentless
    include Composite

    # 'Removes' a child from this Parentless
    #
    # This always succeeds, and never triggers any other action.
    def remove(child)
      child
    end

    def children
      {}
    end

    def url
      ''
    end

    def child_url(_)
      ''
    end

    def parent
      self
    end

    protected

    # 'Adds' a child to this Parentless
    #
    # This always succeeds.
    #
    # @return [Object]  The child.
    def add!(_, child)
      child
    end

    def id_function(_)
      -> { nil }
    end
  end
end
