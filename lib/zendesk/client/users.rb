module Zendesk
  class Client
    module Users

      # ## All GET requests for users
      #
      # ### V1
      #
      #    @zendesk.users                               - returns a list of users (limit 15)
      #    @zendesk.users(:page => 2)                   - returns a list of users (next 15)
      #    @zendesk.users(:current)                     - returns the currently authenticated user
      #    @zendesk.users(123)                          - returns the user with id=123
      #    @zendesk.users("Bob")                        - returns users with name matching all or part of "Bob"
      #    @zendesk.users("Bob", :role => :end_user)    - returns users with name matching all or part of "Bob"
      #
      def users(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        selection = args.first

        case selection
        when nil
          response = get("users", options)
        when :current
          response = get("users/current", options)
        when Integer
          response = get("users/#{selection}", options)
        when String
          options[:query] = selection
          response = get("users", options)
        end

        format.to_s.downcase == "xml" ? response["user"] : response
      end

      # ## Update a user
      #
      # ### V1
      #
      #    @zendesk.update_user(123, {:name => "Wu Tang"})
      #
      def update_user(id, data, options={})
        response = put("users/#{id}", data, options)
        format.to_s.downcase == "xml" ? response["user"] : response
      end

      # ## Create a user
      #
      # ### V1
      #
      #    @zendesk.create_user({:name => "Mr. Miyagi"})
      #
      def create_user(user, options={})
        response = post("users", options.merge(:user => user))
        format.to_s.downcase == "xml" ? response["user"] : response
      end

      # ## Delete a user
      #
      # ### V1
      #
      #    @zendesk.delete_user(123)
      #
      def delete_user(id, options={})
        response = delete("users/#{id}", options)
        format.to_s.downcase == "xml" ? response["user"] : response
      end
    end
  end
end
