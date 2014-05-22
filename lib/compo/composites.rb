require 'compo/composites/composite'
require 'compo/composites/array'
require 'compo/composites/hash'
require 'compo/composites/leaf'
require 'compo/composites/parentless'

module Compo
  # Submodule containing implementations of composite objects
  #
  # These classes only implement the concept of an object containing children,
  # and those children being stored in such a way that they can be retrieved by
  # ID.  For the full Compo experience, including parent tracking, URL
  # referencing, and moving of objects between parents, see the Branches
  # submodule.
  #
  # The Composites are the lowest level of Compo; everything else is an
  # extension to them.
  module Composites
  end
end
