module Compo
  module Finders
    # A method object for finding the root of an item in a composite tree
    #
    # The RootFinder can be used as an Enumerable, where the enumerated items
    # are the path of nodes from the composite to its root, inclusive.
    #
    # Root finders are *not* thread-safe.
    class Root
      include Enumerable

      # Initialises a root finder
      #
      # @api  public
      # @example  Initialises a RootFinder
      #   RootFinder.new(composite)
      #
      # @param leaf [Composite] A composite object whose root is to be found.
      def initialize(leaf)
        @leaf = leaf
      end

      # Finds the root of a composite object
      #
      # @api  public
      # @example  Finds the root of an object
      #   RootFinder.find(composite) { |root| p root }
      #
      # @param (see #initialize)
      #
      # @yieldparam (see #run)
      #
      # @return [Object]  The return value of the block.
      def self.find(*args, &block)
        new(*args).run(&block)
      end

      # Attempts to find the root of this RootFinder's composite object
      #
      # When the resource is found, it will be yielded to the attached block.
      #
      # @api  public
      # @example  Runs an RootFinder, returning the root unchanged.
      #   finder.run { |root| root }
      #   #=> root
      #
      # @yieldparam resource [Object]  The resource found.
      #
      # @return [Object]  The return value of the block.
      def run
        each { |node| yield node if node.is_root? }
      end

      # Performs an action on each node in the path to the root
      #
      # This includes both the root and the object whose root is sought, and
      # runs from the latter to the former.
      #
      # @api  public
      # @example  Prints each item from the object to the root.
      #   finder.each { |item| puts item }
      #
      # @yieldparam resource [Object]  The resource found.
      def each
        node = @leaf
        until node.is_a?(Compo::Composites::Parentless) do
          yield node
          node = node.parent
        end
      end
    end
  end
end
