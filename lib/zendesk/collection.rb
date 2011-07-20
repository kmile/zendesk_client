require "zendesk/connection"
require "zendesk/request"
require "zendesk/paginator"

module Zendesk
  class Collection
    include Connection
    include Request
    include Paginator

    attr_accessor *Config::VALID_OPTIONS_KEYS

    def update(path, data)
      put(path, data)
#       format.to_s.downcase == "xml" ? response["user"] : response
    end

    def create(path, data)
      post(path, data)
    end

    def delete(path, options)
      delete(path, options)
    end

  end
end
