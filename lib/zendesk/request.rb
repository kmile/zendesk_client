module Zendesk
  module Request

    def get(path, options={})
      request(:get, path, options)
    end

    def do_post(path, options={})
      request(:post, path, options)
    end

    def do_put(path, options={})
      request(:put, path, options)
    end

    def do_delete(path, options={})
      request(:delete, path, options)
    end

    private

    def request(method, path, options, format=:json)
      # `connection` defined in lib/zendesk/connection.rb
      response = connection(format).send(method) do |request|
        case method
        when :get, :delete
          puts "#{method.to_s.upcase} #{formatted_path(path, format)} #{options.inspect}"
          request.url(formatted_path(path, format), options)
        when :post, :put
          request.path = formatted_path(path, format)
          request.body = options unless options.empty?
          puts "#{method.to_s.upcase} #{request.path} #{request.body.inspect}"
        end
      end

      response.body
    end

    def formatted_path(path, format)
      [path, format].compact.join(".")
    end
  end
end
