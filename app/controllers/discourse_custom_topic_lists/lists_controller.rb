# frozen_string_literal: true

module ::DiscourseCustomTopicLists
  class ListsController < ::ApplicationController
    requires_plugin PLUGIN_NAME
    skip_before_action :check_xhr, only: [:lists_feed]

    def show
      render json: success_json
    end

    def lists_feed
      discourse_expires_in 1.minute

      raise Discourse::InvalidParameters.new(:topic_list_name) if !params[:topic_list_name]
      topic_query_opts = { no_definitions: !SiteSetting.show_category_definitions_in_topic_lists }

      list_item =
        DiscourseCustomTopicLists::CustomTopicList.new(current_user).find_by_slug(
          params[:topic_list_name],
        )
      raise Discourse::NotFound if !list_item

      topic_query_opts[:q] = list_item["query"]
      %i[page q].each do |key|
        if params.key?(key.to_s)
          value = params[key]
          raise Discourse::InvalidParameters.new(key) if !TopicQuery.validate?(key, value)
          topic_query_opts[key] = value
        end
      end

      @title = "#{SiteSetting.title} - #{list_item["name"]}"
      @link = "#{Discourse.base_url}/lists/#{params[:topic_list_name]}"
      @atom_link = "#{Discourse.base_url}/lists/#{params[:topic_list_name]}.rss"
      @description = list_item["description"]
      @topic_list = TopicQuery.new(current_user, topic_query_opts).list_filter

      render "lists/list", formats: [:rss]
    end
  end
end
