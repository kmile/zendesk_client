require "zendesk/connection"
require "zendesk/request"
require "zendesk/paginator"

module Zendesk
  class Collection
    attr_accessor *Config::VALID_OPTIONS_KEYS

    include Connection
    include Request
    include Paginator
  end
end
