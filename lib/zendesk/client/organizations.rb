module Zendesk
  class Client
    module Organizations
      # ## GET all organizations or a single organization by id
      #
      # ### V1
      #
      #    @zendesk.organizations
      #    @zendesk.organizations(123)
      #
      def organizations(*args)
        OrganizationsCollection.new(self, *args)
      end
    end

    class OrganizationsCollection < Collection

      def initialize(client, *args)
        clear_cache
        @client = client
        @query  = args.last.is_a?(Hash) ? args.pop : {}

        case selection = args.shift
        when nil
          @query[:path] = "organizations"
        when Integer
          @query[:path] = "organizations/#{selection}"
        end
      end

      # ## Update a organization by id
      #
      # ### V1
      #
      #    @zendesk.organizations(123).update({:name => "Sort of Cool Guys"})
      #
      #    # optional block syntax
      #    @zendesk.organizations(123).update do |org|
      #      org[:name] = "Just People"
      #      org[:description] = "That's all"
      #    end
      #
      def update(data={})
        yield data if block_given?
        do_put(@query.delete(:path), @query.merge(:organization => data))
      end

      # ## Create a organization
      #
      # ### V1
      #
      #    @zendesk.organizations.create({:name => "Cool Guys", :agents => [123, 456, 789]})
      #
      #    # optional block syntax
      #    @zendesk.organizations.create do |org|
      #      org[:name] = "Cool Guys"
      #      org[:description] = "wish you could be this cool"
      #    end
      #
      def create(data={})
        yield data if block_given?
        do_post(@query.delete(:path), @query.merge(:organization => data))
      end

      # ## Delete organization
      #
      # ### V1
      #
      #    @zendesk.organizations(123).delete
      #
      def delete(options={})
        do_delete(@query.delete(:path), options)
      end
    end
  end
end
