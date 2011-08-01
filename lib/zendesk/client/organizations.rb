module Zendesk
  class Client
    module Organizations
      # @zendesk.organizations
      # @zendesk.organizations(123)
      def organizations(*args)
        OrganizationsCollection.new(self, *args)
      end
    end

    class OrganizationsCollection < Collection
      def initialize(client, *args)
        super(client, :organizations, *args)
      end
    end
  end
end
