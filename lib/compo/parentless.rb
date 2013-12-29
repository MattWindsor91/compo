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

    def url
      ''
    end
  end
end
