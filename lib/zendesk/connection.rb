require "rubygems"
require "faraday"

module Zendesk
  module Connection
    def connection
      options = {
        :headers => {'Accept' => "application/#{format}", 'User-Agent' => user_agent},
        :proxy => proxy,
        :ssl => {:verify => false},
        :endpoint => "https://#{subdomain}.zendesk.com",
        :url => endpoint
      }

      Faraday.new(options) do |builder|
        builder.use Faraday::Request::MultipartWithFile
        builder.use Faraday::Request::OAuth, authentication if authenticated?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::RaiseHttp4xx
        case format.to_s.downcase
        when 'json'
          builder.use Faraday::Response::ParseJson
        when 'xml'
          builder.use Faraday::Response::ParseXml
        end
        builder.use Faraday::Response::RaiseHttp5xx
        builder.adapter(adapter)
      end
    end
  end
end
