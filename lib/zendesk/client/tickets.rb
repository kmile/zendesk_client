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

      # TODO: document all the fields
      def initialize(client, *args)
        super(client, :tickets, *args)
      end
    end
  end
end
