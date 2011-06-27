module Zendesk
  class Client
    module Users

      # All GET requests for users
      #
      # @zendesk.users(:all)                         - returns a list of all users
      # @zendesk.users(:current)                     - returns the currently authenticated user
      # @zendesk.users(123)                          - returns the user with id=123
      # @zendesk.users("Bob")                        - returns users with name matching all or part of "Bob"
      # @zendesk.users("Bob", :role => :end_user)    - returns users with name matching all or part of "Bob"
      #
      def users(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        selection = args.first || :all
        case selection
        when :all
          response = get("users", options)
        when :current
          response = get("users/current", options)
        when Integer
          response = get("users/#{selection}", options)
        when String
          options[:query] = selection
          response = get("users", options)
        when Hash
          group = selection.delete(:group)
          organization = selection.delete(:organization)

          abort "only one or the other, @zendesk.users(:group => 123) or @zendesk.users(:organization => 123)" if group && organization

          if group
            response = get("groups/#{group}/users", options)
          elsif organization
            response = get("organizations/#{organization}/users", options)
          end
        end

        format.to_s.downcase == "xml" ? response["user"] : response
      end
    end
  end
end
