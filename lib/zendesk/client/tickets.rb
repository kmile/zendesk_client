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
        super(client, :tickets, *args)
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

      # ## Delete ticket
      #
      # ### V1
      #
      #    @zendesk.tickets(123).delete
      #
    end
  end
end
