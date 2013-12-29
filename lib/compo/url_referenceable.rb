module Compo
  # Adds ID-based 'URL's to Compo classes
  #
  # For the purposes of this module, a URL is a string of slash-delimited IDs
  # representing the location of a Composite in the tree structure formed by
  # its ancestors.  Depending on the types of IDs used in the structure, the
  # URLs may not actually be literal Uniform Resource Locators.
  #
  # This module expects its includer to define #parent and #id.  These are
  # defined, for example, by the Compo::ParentTracker mixin.
  module UrlReferenceable
    # Returns the URL of this object
    #
    # The #url of a Composite is defined inductively as '' for composites that
    # have no parent, and the joining of the parent URL and the current ID
    # otherwise.
    #
    # The result of #url can be used to give a URL hierarchy to Composites.
    #
    # @api  public
    # @example  Gets the URL of an object with no parent.
    #   orphan.url
    #   #=> ''
    # @example  Gets the URL of an object with a parent.
    #   leaf.url
    #   #=> 'grandparent_id/parent_id/id'
    #
    # @return [String]  The URL of this object.
    def url
      parent.child_url(id)
    end

    def child_url(child_id)
      [url, child_id].join('/')
    end

    # Returns the URL of this object's parent
    #
    # @api  public
    # @example  Gets the parent URL of an object with no parent.
    #   orphan.parent_url
    #   #=> nil
    # @example  Gets the URL of an object with a parent.
    #   leaf.parent_url
    #   #=> 'grandparent_id/parent_id'
    #
    # @return [String]  The URL of this object's parent, or nil if there is no
    #   parent.
    def parent_url
      parent.nil? ? nil : parent.url
    end
  end
end
