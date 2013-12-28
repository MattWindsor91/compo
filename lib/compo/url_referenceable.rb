module Compo
  module UrlReferenceable
    def url
      parent.nil? ? '' : [parent_url, id].join('/')
    end

    def parent_url
      parent.nil? ? nil : parent.url
    end
  end
end
