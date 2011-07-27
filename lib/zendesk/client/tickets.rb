module Zendesk
  class Client
    module Tickets
      # ## GET all tickets or a single ticket by id
      #
      # ### V1
      #
      #    @zendesk.tickets
      #    @zendesk.tickets(123)
      #
      def tickets(*args)
        TicketsCollection.new(self, *args)
      end
    end

    class TicketsCollection < Collection

      def initialize(client, *args)
        clear_cache
        @client = client
        @query  = args.last.is_a?(Hash) ? args.pop : {}

        case selection = args.shift
        when nil
          @query[:path] = "tickets"
        when Integer
          @query[:path] = "tickets/#{selection}"
        end
      end

      # ## Create a ticket
      #
      # ### V1
      #
      #    @zendesk.tickets.create({:subject => "My phone fell in the toilet", :description => "HALP ME!"})
      #
      #    # optional block syntax
      #    @zendesk.tickets.create do |ticket|
      #      ticket[:subject] = "My phone fell in the toilet"
      #      ticket[:description] = "HALP ME!"
      #    end
      #
      def create(data={})
        yield data if block_given?
        do_post(@query.delete(:path), @query.merge(:ticket => data))
      end

      # ## Update a ticket by id
      #
      # ### V1
      #
      #    @zendesk.tickets(123).update({:subject => "My phone fell in the toilet"})
      #
      #    # optional block syntax
      #    @zendesk.tickets(123).update do |ticket|
      #      ticket[:subject] = "My phone fell in the toilet"
      #      ticket[:description] = "That's all"
      #    end
      #
      def update(data={})
        yield data if block_given?
        do_put(@query.delete(:path), @query.merge(:ticket => data))
      end

      # ## Delete ticket
      #
      # ### V1
      #
      #    @zendesk.tickets(123).delete
      #
      def delete(options={})
        do_delete(@query.delete(:path), options)
      end
    end
  end
end
