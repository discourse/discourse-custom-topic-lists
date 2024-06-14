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
register_asset "stylesheets/common/common.scss"

after_initialize do
  add_to_serializer(:current_user, :custom_topic_lists) do
    begin
      custom_lists = JSON.parse(SiteSetting.custom_topic_lists) || []
      current_user = scope.user
      custom_lists.select do |list|
        allowed_groups = list["access"].split(/(?:,|\s)\s*/).map(&:to_i)
        allowed_groups = [Group::AUTO_GROUPS[:everyone]] if allowed_groups.empty?
        current_user.in_any_groups?(allowed_groups)
      end
    rescue StandardError
      []
    end
  end
end
