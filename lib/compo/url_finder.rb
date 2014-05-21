module Compo
  # A 'UrlFinder' finds an object in a composite tree via its URL
  #
  # It is a method object that implements only the finding of a specific URL.
  class UrlFinder
    # Initialises a UrlFinder
    #
    # @param root [Composite] A composite object serving as the root of the
    #   search tree, and the URL.
    #
    # @param url [String] A partial URL that follows this model object's URL
    #   to form the URL of the resource to locate.  Can be nil, in which case
    #   this object is returned.
    #
    # @param missing_proc [Proc] A proc to call, with the requested URL, if the
    #   resource could not be found.  If nil (the default), this raises a string
    #   exception.
    def initialize(root, url, missing_proc: nil)
      @root         = root
      @url          = url
      @missing_proc = missing_proc || method(:default_missing_proc)

      reset
    end

    # Finds the model object at a URL, given a model root
    #
    # @param (see #initialize)
    #
    # @yieldparam (see #run)
    #
    # @return (see #run)
    def self.find(*args, &block)
      new(*args).run(&block)
    end

    # Attempts to find a child resource with the given partial URL
    #
    # If the resource is found, it will be yielded to the attached block;
    # otherwise, an exception will be raised.
    #
    # @yieldparam resource [ModelObject] The resource found.
    # @yieldparam args [Array] The splat from above.
    #
    # @return [Object]  The return value of the block.
    def run
      # We're traversing down the URL by repeatedly splitting it into its
      # head (part before the next /) and tail (part after).  While we still
      # have a tail, then the URL still needs walking down.
      reset
      descend until hit_end_of_url?
      yield @resource
    end

    private

    def descend
      descend_url
      next_resource
      fail_with_no_resource if @resource.nil?
    end

    def next_resource
      @resource = @resource.get_child_such_that { |id| id.to_s == @next_id }
    end

    def fail_with_no_resource
      # If the proc returns a value instead of raising an error, then set
      # things up so that value is yielded in place of the missing resource.
      @tail = nil
      @resource = @missing_proc.call(@url)
    end

    def default_missing_proc(url)
      fail("Could not find resource: #{url}")
    end

    def hit_end_of_url?
      @tail.nil? || @tail.empty?
    end

    def descend_url
      @next_id, @tail = @tail.split('/', 2)
    end

    def reset
      @head, @tail = nil, trimmed_url
      @resource = @root
    end

    def trimmed_url
      first, last = 0, @url.length
      first += 1 if @url.start_with?('/')
      last  -= 1 if @url.end_with?('/')

      @url[first...last]
    end
  end
end
