require "rubygems"
require "faraday"
require "json"
require "base64"

module Zendesk
  class Connection
    def initialize(account, email, password)
      @zen = Faraday.new(:url => "https://#{account}.zendesk.com/") do |c|
        c.request :url_encoded
        c.request :json
        c.response :logger
        c.adapter :net_http
      end
      @zen.basic_auth email, password
      @zen
    end

    # GET resources
    %w[ users organizations groups tickets attachments tags forums entries ticket_fields macros ].each do |resource|
      class_eval <<-METHOD
        def #{resource}
          @#{resource} ||= @zen.get "#{resource}.json"
          JSON.parse(@#{resource}.body)
        end
      METHOD
    end

    # delegate to faraday
    def method_missing(method, *args, &block)
      @zen.send(method, *args, &block)
    end
  end
end

@conn = Zendesk::Connection.new("support", "dclendenin@zendesk.com", Base64.decode64("ZXJhNTQ0NXRoYWQ=\n"))

resp = zen.users
puts resp.body
resp = zen.organizations
puts resp.body
resp = zen.groups
puts resp.body
resp = zen.tickets
puts resp.body
resp = zen.attachments
puts resp.body
resp = zen.tags
puts resp.body
resp = zen.entries
puts resp.body
resp = zen.ticket_fields
puts resp.body
resp = zen.macros
puts resp.body

