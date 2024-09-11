# frozen_string_literal: true

# name: discourse-custom-topic-lists
# about: add custom topic lists to your site
# meta_topic_id: 311186
# version: 0.0.1
# authors: Discourse
# url: https://github.com/discourse/discourse-custom-topic-lists
# required_version: 2.7.0

enabled_site_setting :discourse_custom_topic_lists_enabled
module ::DiscourseCustomTopicLists
  PLUGIN_NAME = "discourse-custom-topic-lists"
end

require_relative "lib/discourse_custom_topic_lists/engine"
require_relative "lib/discourse_custom_topic_lists/custom_topic_list"
register_asset "stylesheets/common/common.scss"

after_initialize do
  require_relative "app/controllers/discourse_custom_topic_lists/lists_controller"

  Discourse::Application.routes.append { mount ::DiscourseCustomTopicLists::Engine, at: "" }

  add_to_serializer(:site, :custom_topic_lists) do
    DiscourseCustomTopicLists::CustomTopicList.new(scope.user).lists
  end
end
