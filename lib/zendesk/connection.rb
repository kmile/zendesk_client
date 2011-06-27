require "faraday_middleware"
require "zendesk/response/raise_http_4xx"

module Zendesk
  module Connection
    private

    # This method sets up HTTP data for all requests
    def connection(raw=false)
      options = {
        :headers => {"Accept" => "application/#{format}", "User-Agent" => user_agent},
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => endpoint
      }

      Faraday.new(options) do |builder|
        # As with Rack, order matters, so be mindful

        # TODO: builder.use Zendesk::Request::MultipartWithFile
#         builder.use Faraday::Request::BasicAuth, authentication if authenticated?
        builder.use Faraday::Request::OAuth, authentication if authenticated?

        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded

#         builder.use Zendesk::Response::RaiseHttp4xx

        unless raw
          case format.to_s.downcase
          when "json"
            builder.use Faraday::Response::ParseJson
          when "xml"
            builder.use Faraday::Response::ParseXml
          end
        end

#         builder.use Faraday::Response::RaiseHttp5xx

        # finally
        builder.adapter(adapter)
      end
    end
  end
end
