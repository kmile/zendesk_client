module Zendesk
  class Client
    module Users
      # @zendesk.users(:all)     - returns a list of all users
      # @zendesk.users(:current) - returns the currently authenticated user
      # @zendesk.users(123)      - returns the user with id=123
      def users(selection=nil, options={})
        case selection
        when :all, nil
          response = get("users", options)
          return format.to_s.downcase == "xml" ? response["users"] : response
        when :current
          response = get("users/current", options)
          return format.to_s.downcase == "xml" ? response["user"] : response
        when Integer
          response = get("users/#{selection}", options)
          return format.to_s.downcase == "xml" ? response["user"] : response
        when Hash
          group = selection.delete(:group)
          organization = selection.delete(:organization)
          abort "only one or the other, @zendesk.users(:group => 123) or @zendesk.users(:organization => 123)" if group && organization
          if group
            response = get("groups/#{group}/users", options)
            return format.to_s.downcase == "xml" ? response["user"] : response
          elsif organization
            response = get("organizations/#{organization}/users", options)
            return format.to_s.downcase == "xml" ? response["user"] : response
          end
        end
      end
    end
  end
end
