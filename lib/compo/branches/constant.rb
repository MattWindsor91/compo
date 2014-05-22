require 'compo/branches/leaf'

module Compo
  module Branches
    # A Leaf containing a constant value
    #
    # The value can be retrieved using #value.
    class Constant < Leaf
      # Initialises the Constant
      #
      # @api public
      # @example  Initialising a Constant with a given value.
      #   Constant.new(:value)
      #
      # @param value [Object] The value of the constant.
      #
      def initialize(value)
        super()
        @value = value
      end

      # Returns the current value of this Constant
      #
      # @api public
      # @example  Retrieving a Constant's value.
      #   const = Constant.new(:spoon)
      #   const.value
      #   #=> :spoon
      #
      # @return [Object]  The Constant's internal value.
      attr_reader :value
    end
  end
end
