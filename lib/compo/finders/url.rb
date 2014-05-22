module Compo
  module Finders
    # A method object for finding an item in a composite tree via its URL
    #
    # These are *not* thread-safe.
    class Url
      # Initialises an URL finder
      #
      # @api  public
      # @example  Initialises an UrlFinder with default missing resource
      #   handling.
      #   UrlFinder.new(composite, 'a/b/c')
      # @example  Initialises an UrlFinder returning a default value.
      #   UrlFinder.new(composite, 'a/b/c', missing_proc=->(_) { :default })
      #
      # @param root [Composite] A composite object serving as the root of the
      #   search tree, and the URL.
      #
      # @param url [String] A partial URL that follows this model object's URL
      #   to form the URL of the resource to locate.  Can be nil, in which case
      #   this object is returned.
      #
      # @param missing_proc [Proc] A proc to call, with the requested URL, if
      #   the resource could not be found.  If nil (the default), this raises a
      #   string exception.
      def initialize(root, url, missing_proc: nil)
        @root         = root
        @url          = url
        @missing_proc = missing_proc || method(:default_missing_proc)

        reset
      end

      # Finds the model object at a URL, given a model root
      #
      # @api  public
      # @example  Finds a URL with default missing resource handling.
      #   UrlFinder.find(composite, 'a/b/c') { |item| p item }
      #
      # @param (see #initialize)
      #
      # @yieldparam (see #run)
      #
      # @return [Object]  The return value of the block.
      def self.find(*args, &block)
        new(*args).run(&block)
      end

      # Attempts to find a child resource with the given partial URL
      #
      # If the resource is found, it will be yielded to the attached block;
      # otherwise, an exception will be raised.
      #
      # @api  public
      # @example  Runs an UrlFinder, returning the item unchanged.
      #   finder.run { |item| item }
      #   #=> item
      #
      # @yieldparam resource [ModelObject]  The resource found.
      # @yieldparam args [Array]  The splat from above.
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

      # Performs a descending step in the URL finder
      #
      # This tries to move down a level of the URL hierarchy, fetches the
      # resource at that level, and fails according to @missing_proc if there is
      # no such resource.
      #
      # @api  private
      #
      # @return [Void]
      def descend
        descend_url
        next_resource
        fail_with_no_resource if @resource.nil?
      end

      # Seeks to the next resource pointed at by @next_id
      #
      # @api  private
      #
      # @return [Void]
      def next_resource
        @resource = @resource.get_child_such_that { |id| id.to_s == @next_id }
      end

      # Fails, using @missing_proc, due to a missing resource
      #
      # @api  private
      #
      # @return [Void]
      def fail_with_no_resource
        # If the proc returns a value instead of raising an error, then set
        # things up so that value is yielded in place of the missing resource.
        @tail = nil
        @resource = @missing_proc.call(@url)
      end

      # Default value for @missing_proc
      #
      # @api  private
      #
      # @param url [String]  The URL whose finding failed.
      #
      # @return [Void]
      def default_missing_proc(url)
        fail("Could not find resource: #{url}")
      end

      # Decides whether we have reached the end of the URL
      #
      # @api  private
      #
      # @return [Boolean]  Whether we have hit the end of the URL.
      def hit_end_of_url?
        @tail.nil? || @tail.empty?
      end

      # Splits the tail on the next URL level
      #
      # @api  private
      #
      # @return [Void]
      def descend_url
        @next_id, @tail = @tail.split('/', 2)
      end

      # Resets this UrlFinder so it can be used again
      #
      # @api  private
      #
      # @return [Void]
      def reset
        @next_id, @tail = nil, trimmed_url
        @resource = @root
      end

      # Removes any leading or trailing slash from the URL, returning the result
      #
      # This only removes one leading or trailing slash.  Thus, '///' will be
      # returned as '/'.
      #
      # @api  private
      #
      # @return [String] The URL with no trailing or leading slash.
      def trimmed_url
        first, last = 0, @url.length
        first += 1 if @url.start_with?('/')
        last  -= 1 if @url.end_with?('/')

        @url[first...last]
      end
    end
  end
end
