# frozen_string_literal: true

module DiscourseCustomTopicLists
  class CustomTopicList
    def initialize(user)
      @user = user
    end

    def lists
      @custom_lists ||=
        begin
          custom_lists =
            begin
              JSON.parse(SiteSetting.custom_topic_lists) || []
            rescue JSON::ParserError
              []
            end
          custom_lists.select! do |list|
            allowed_groups =
              list["access"]
                .split(/(?:,|\s)\s*/)
                .map { |group_name| Group.find_by(name: group_name)&.id }
                .compact
            allowed_groups = [Group::AUTO_GROUPS[:everyone]] if allowed_groups.empty?
            next true if allowed_groups.include?(Group::AUTO_GROUPS[:everyone])
            next false if @user.nil?
            @user.in_any_groups?(allowed_groups)
          end
          custom_lists
        end
    end

    def find_by_slug(slug)
      lists.find { |list| list["slug"] == slug }
    end
  end
end
