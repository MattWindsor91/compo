module Compo
  module UrlReferenceable
    def url
      ''
    end

    def parent_url
      parent.url unless parent.nil?
      nil
    end
  end
end
