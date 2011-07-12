require "zendesk/config"
require "zendesk/connection"
require "zendesk/request"
require "zendesk/authentication"

module Zendesk
  class API
    attr_accessor *Config::VALID_OPTIONS_KEYS
    attr_accessor :endpoint, :email, :password # dumb, will fix later

    # Creates a new Client
    def initialize(options={}, &block)
      options = Zendesk.options.merge(options)
      Config::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end

      yield self if block_given?
    end

    # Both of these methods are very naive
    # just sketching it out for now
    def account(uri)
      @endpoint = uri
    end

    def basic_auth(email, password)
      @email, @password = email, password
    end

    include Connection
    include Request
    include Authentication
  end
end
