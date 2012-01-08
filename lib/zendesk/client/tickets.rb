module Zendesk
  class Client
    module Tickets
      # @zendesk.tickets
      # @zendesk.tickets(123)
      def tickets(*args)
        TicketsCollection.new(self, *args)
      end
    end

    class TicketsCollection < Collection
      # TODO: document all the fields
      def initialize(client, *args)
        query = args.last.is_a?(Hash) ? args.pop : {}
        id = args.shift

        if view_id = query.delete(:view)
          raise ArgumentError "cannot specify ticket id and view id in the same query" unless id.nil?

          id = view_id
          query[:path] = 'rules'
        end
        
        super(client, :tickets, id, query)
      end

      def views
        @query[:path] = "/rules"
        self
      end

      # TODO: @zendesk.ticket(123).public_comment({ ... })
      # TODO: @zendesk.ticket(123).private_comment({ ... })
    end
  end
end
