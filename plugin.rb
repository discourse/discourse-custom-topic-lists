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

after_initialize do
  add_to_serializer(:current_user, :custom_topic_lists) do
    custom_lists = JSON.parse(SiteSetting.custom_topic_lists) || []
    current_user_groups = scope.user.groups.pluck(:name)

    custom_lists.select do |list|
      allowed_groups = list["access"].split(/(?:,|\s)\s*/)
      allowed_groups.empty? ||
        allowed_groups.any? { |group| current_user_groups.include?(group.strip) }
    end
  end
end
