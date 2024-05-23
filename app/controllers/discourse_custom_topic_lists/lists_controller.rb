# frozen_string_literal: true

module ::DiscourseCustomTopicLists
  class ListsController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    def show
      render json: { hello: "world" }
    end
  end
end
