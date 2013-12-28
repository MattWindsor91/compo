module Compo
  module UrlReferenceable
    def url
      ''
    end

    def parent_url
      parent.nil? ? nil : parent.url
    end
  end
end
