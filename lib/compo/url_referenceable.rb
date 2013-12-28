module Compo
  module UrlReferenceable
    def url
      id unless parent.nil?
      ''
    end

    def parent_url
      parent.nil? ? nil : parent.url
    end
  end
end
