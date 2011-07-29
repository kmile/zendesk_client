module Zendesk
  class Client
    module Tags
      # @zendesk.tags
      # @zendesk.tags(123)
      def tags(*args)
        TagsCollection.new(self, *args)
      end
    end

    class TagsCollection < Collection
      def initialize(client, *args)
        super(client, :tags, *args)
      end
    end
  end
end
