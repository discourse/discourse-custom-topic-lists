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
  add_to_serializer(:site, :custom_topic_lists) do
    custom_lists =
      begin
        JSON.parse(SiteSetting.custom_topic_lists) || []
      rescue JSON::ParserError
        []
      end
    current_user = scope.user
    custom_lists.select! do |list|
      allowed_groups =
        list["access"]
          .split(/(?:,|\s)\s*/)
          .map { |group_name| Group.find_by(name: group_name)&.id }
          .compact
      allowed_groups = [Group::AUTO_GROUPS[:everyone]] if allowed_groups.empty?
      next true if allowed_groups.include?(Group::AUTO_GROUPS[:everyone])
      next false if current_user.nil?
      current_user.in_any_groups?(allowed_groups)
    end
    custom_lists
  end
end
