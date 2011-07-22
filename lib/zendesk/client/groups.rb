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
        GroupsCollection.new(self, *args)
      end
    end

    class GroupsCollection < Collection

      def initialize(client, *args)
        clear_cache
        @client = client
        @query  = args.last.is_a?(Hash) ? args.pop : {}

        case selection = args.shift
        when nil
          @query[:path] = "groups"
        when Integer
          @query[:path] = "groups/#{selection}"
        end
      end

      # ## Update a group by id
      #
      # ### V1
      #
      #    @zendesk.groups(123).update({:name => "Sort of Cool Guys"})
      #
      #    # optional block syntax
      #    @zendesk.groups(123).update do |group|
      #      group[:name] = "Just People"
      #      group[:description] = "That's all"
      #    end
      #
      def update(data={})
        yield data if block_given?
        do_put(@query.delete(:path), @query.merge(:group => data))
      end

      # ## Create a group
      #
      # ### V1
      #
      #    @zendesk.groups.create({:name => "Cool Guys", :agents => [123, 456, 789]})
      #
      #    # optional block syntax
      #    @zendesk.groups.create do |group|
      #      group[:name] = "Cool Guys"
      #      group[:description] = "wish you could be this cool"
      #    end
      #
      def create(data={})
        yield data if block_given?
        do_post(@query.delete(:path), @query.merge(:group => data))
      end

      # ## Delete group
      #
      # ### V1
      #
      #    @zendesk.groups(123).delete
      #
      def delete(options={})
        do_delete(@query.delete(:path), options)
      end
    end
  end
end
