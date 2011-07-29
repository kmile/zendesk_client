module Zendesk
  class Client
    module Groups
      # ## GET all groups or a single group by id
      #    @zendesk.groups
      #    @zendesk.groups(123)
      #
      def groups(*args)
        GroupsCollection.new(self, *args)
      end
    end

    class GroupsCollection < Collection

      def initialize(client, *args)
        super(client, :groups, *args)
      end

    end
  end
end
