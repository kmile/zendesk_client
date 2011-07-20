module Zendesk
  class API # inherited by Client
    attr_accessor *Config::VALID_OPTIONS_KEYS

    # Zendesk::Client.new
    def initialize(options={})
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

#     def inspect
#       "#<#{self.class} @endpoint=#{endpoint} @email=#{email} @password=****** @proxy=#{proxy} @cache=#{@cache}>"
#     end
  end
end
