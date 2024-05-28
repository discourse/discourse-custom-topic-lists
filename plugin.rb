# frozen_string_literal: true

# name: discourse-custom-topic-lists
# about: add custom topic lists to your site
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_custom_topic_lists_enabled

module ::DiscourseCustomTopicLists
  PLUGIN_NAME = "discourse-custom-topic-lists"
end

require_relative "lib/discourse_custom_topic_lists/engine"
register_asset "stylesheets/common/common.scss"

after_initialize {}
