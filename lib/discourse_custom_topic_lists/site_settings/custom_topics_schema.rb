# frozen_string_literal: true

module DiscourseCustomTopicLists
  module SiteSettings
    class CustomTopicsSchema
      def self.schema
        @schema ||= {
          type: "array",
          uniqueItems: true,
          format: "tabs-top",
          items: {
            title: "Custom Topic List",
            type: "object",
            format: "grid-strict",
            properties: {
              icon: {
                title: "Icon",
                type: "string",
                description: "i.e. question",
              },
              name: {
                title: "Name",
                type: "string",
                description: "i.e. Arts and media",
              },
              path: {
                title: "Path",
                type: "string",
                description: "i.e. arts-and-media",
              },
              query: {
                title: "Query",
                type: "string",
                description: "i.e. category:arts-media",
              },
              access: {
                title: "Who can see",
                type: "string",
                description:
                  "Enter comma, or space separated user group names. Only the members of those groups can see this topic. Leave empty to allow all logged-in users.",
              },
            },
          },
        }
      end
    end
  end
end
