require "zendesk/config"
require "zendesk/connection"
require "zendesk/request"
require "zendesk/authentication"

module Zendesk
  class API
    attr_accessor *Config::VALID_OPTIONS_KEYS
    attr_accessor :endpoint

    # Creates a new Client
    def initialize(subdomain, options={})
      @endpoint = "https://#{subdomain}.zendesk.com"
      options[:subdomain] = subdomain

      options = Zendesk.options.merge(options)
      Config::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Connection
    include Request
    include Authentication
  end
end
