module Zendesk
  class Client
    module Users
      # Returns a list of users for an account
      #
      # @overload users(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @return [JSON, XML] list of users
      #   @example Return a list of users for an account
      #     @account.users
      #     @account.users(:only => [:agents])
      #     @account.users(:exclude => [:end_users])
      # @format :json, :xml
      # @authenticated false
      # @rate_limited true
      # @see http://dev.twitter.com/doc/get/users/show
      def users(options)
        response = get('users', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end
    end
  end
end
