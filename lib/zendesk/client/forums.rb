module Zendesk
  class Client
    module Forums
      # ## GET all forums or a single forum by id
      #
      # ### V1
      #
      #    @zendesk.forums
      #    @zendesk.forums(123)
      #
      def forums(*args)
        ForumsCollection.new(self, *args)
      end
    end

    class ForumsCollection < Collection

      def initialize(client, *args)
        clear_cache
        @client = client
        @query  = args.last.is_a?(Hash) ? args.pop : {}

        case selection = args.shift
        when nil
          @query[:path] = "forums"
        when Integer
          @query[:path] = "forums/#{selection}"
        end
      end

      # ## GET all entries for a forum
      #
      # ### V1
      #
      #   @zendesk.forums(123).entries
      #
      def entries
        @query[:path] += "/entries"
        self
      end

      # ## Update a forum by id
      #
      # ### V1
      #
      #    @zendesk.forums(123).update({:name => "Sort of Cool Guys"})
      #
      #    # optional block syntax
      #    @zendesk.forums(123).update do |org|
      #      org[:name] = "Just People"
      #      org[:description] = "That's all"
      #    end
      #
      def update(data={})
        yield data if block_given?
        do_put(@query.delete(:path), @query.merge(:forum => data))
      end

      # ## Create a forum
      #
      # ### V1
      #
      #    @zendesk.forums.create({:name => "Cool Guys", :agents => [123, 456, 789]})
      #
      #    # optional block syntax
      #    @zendesk.forums.create do |org|
      #      org[:name] = "Cool Guys"
      #      org[:description] = "wish you could be this cool"
      #    end
      #
      def create(data={})
        yield data if block_given?
        do_post(@query.delete(:path), @query.merge(:forum => data))
      end

      # ## Delete forum
      #
      # ### V1
      #
      #    @zendesk.forums(123).delete
      #
      def delete(options={})
        do_delete(@query.delete(:path), options)
      end
    end
  end
end
