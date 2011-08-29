require "active_support/inflector" # `singularize`
# require "zendesk/request"
require "zendesk/connection"
require "zendesk/paginator"

module Zendesk
  class Collection
    include Paginator  # `clear_cache`, `fetch`, `each`, `[]`, `page`, `per_page`, `method_missing`
    extend Connection  # `connection`
    include Connection

    attr_accessor *Config::VALID_OPTIONS_KEYS

    def initialize(client, resource, *args)
      clear_cache

      @client   = client
      @resource = resource.to_s.singularize
      @query    = args.last.is_a?(Hash) ? args.pop : {}

      case id = args.shift
      when nil
        @query[:path] = resource.to_s
      when Integer
        @query[:path] = "#{resource}/#{id}"
      else
        raise ArgumentError, "argument must be a numeric id."
      end
    end

    def get(path, options={})
      request(:get, path, options)
    end

    def put(path, options={})
      request(:put, path, options)
    end

    def post(path, options={})
      request(:post, path, options)
    end

    def create(data={})
      yield data if block_given?
      request(:post, @query.delete(:path), @query.merge(@resource.to_sym => data))
    end

    def update(data={})
      yield data if block_given?
      request(:put, @query.delete(:path), @query.merge(@resource.to_sym => data))
    end

    def delete(options={})
      request(:delete, @query.delete(:path), options)
    end


    private #######################################################


    def request(method, path, options)
      # `connection` defined in lib/zendesk/connection.rb
      response = connection(@client).send(method) do |request|
        case method
        when :get, :delete
          request.url(formatted_path(path, format), options)
        when :post, :put
          request.path = formatted_path(path, format)
          request.body = options unless options.empty?
        end
      end

      response.body
    end

    def formatted_path(path, format)
      [path, format].compact.join(".")
    end

  end
end
