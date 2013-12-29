require 'compo'

module Compo
  class Parentless
    include Composite

    def add(_, child)
      child.remove_parent
      child
    end

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

    def id_function(_)
      -> { nil }
    end
  end
end
