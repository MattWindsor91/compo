require 'compo'

module Compo
  class Parentless
    include Composite

    def add!(_, child)
      child
    end

    def remove!(child)
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
  end
end
