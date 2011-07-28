module Zendesk
  class Client
    module TicketFields
      # ## GET all ticket_fields or a single ticket_field by id
      #
      # ### V1
      #
      #    @zendesk.ticket_fields
      #    @zendesk.ticket_fields(123)
      #
      def ticket_fields(*args)
        TicketFieldsCollection.new(self, *args)
      end

      class TicketFieldsCollection < Collection
        def initialize(client, *args)
          clear_cache
          @client = client
          @query = args.last.is_a?(Hash) ? args.pop : {}
        end
      end
    end
  end
end
