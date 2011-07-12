module Zendesk
  class Client
    module Groups

      # ## GET all groups or a single group by id
      #
      # ### V1
      #
      #    @zendesk.groups
      #    @zendesk.groups(123)
      #
      def groups(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        selection = args.first

        case selection
        when nil
          response = get("groups", options)
        when Integer
          response = get("groups/#{selection}", options)
        end
      end

      # ## GET all groups or a single group by id
      #
      # ### V1
      #
      #    @zendesk.update_group(123, {:name => "Sort of Cool Guys"})
      #
      def update_group(id, data, options={})
        put("groups/#{id}", data, options)
      end

      # ## GET all groups or a single group by id
      #
      # ### V1
      #
      #    @zendesk.create_group({:name => "Cool Guys", :agents => [123, 456, 789]})
      #
      def create_group(group, options={})
        post("groups", options.merge(:group => group))
      end

      # ## Delete group
      #
      # ### V1
      #
      #    @zendesk.delete_group(123)
      #
      def delete_group(id, options={})
        delete("groups/#{id}", options)
      end
    end
  end
end
