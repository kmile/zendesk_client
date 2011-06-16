module Zendesk
  class Client
    module Users
      # Returns a list of users for an account
      def users(options)
        response = get("users", options)
        format.to_s.downcase == "xml" ? response["users"] : response
      end
    end
  end
end
