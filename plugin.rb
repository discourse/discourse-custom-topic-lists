# frozen_string_literal: true

# name: discourse-custom-topic-lists
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :custom_topic_lists_enabled

module ::DiscourseCustomTopicLists
  PLUGIN_NAME = "discourse-custom-topic-lists"
end

require_relative "lib/discourse_custom_topic_lists/engine"

after_initialize do
  add_to_serializer(:site, :custom_topic_lists) do
    [{ path: "arts-and-media", query: "category:arts-media", title: "Arts and media custom list" }]
  end
end
