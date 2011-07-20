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
        clear_cache
        @query = args.last.is_a?(Hash) ? args.pop : {}
        selection = args.first

        case selection
        when nil
          @query[:path] = "groups"
        when Integer
          @query[:path] = "groups/#{selection}"
        end
      end

      # ## GET all groups or a single group by id
      #
      # ### V1
      #
      #    @zendesk.update_group(123, {:name => "Sort of Cool Guys"})
      #
      def update(options={})
        data = {}
        yield data if block_given?
        response = put(@query.delete(:path), @query.merge({:group => data}))
        format.to_s.downcase == "xml" ? response["group"] : response
      end

      # ## GET all groups or a single group by id
      #
      # ### V1
      #
      #    @zendesk.create_group({:name => "Cool Guys", :agents => [123, 456, 789]})
      #
      def create(options={})
        data = {}
        yield data if block_given?
        post("groups", options.merge(:group => data))
        format.to_s.downcase == "xml" ? response["group"] : response
      end

      # ## Delete group
      #
      # ### V1
      #
      #    @zendesk.delete_group(123)
      #
      def delete(options={})
        response = delete(@query[:path], options)
        format.to_s.downcase == "xml" ? response["group"] : response
      end
    end
  end
end
