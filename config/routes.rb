# frozen_string_literal: true

DiscourseCustomTopicLists::Engine.routes.draw do
  get "lists/:topic_list_name.rss" => "lists#lists_feed", :format => :rss
  get "lists/:topic_list_name" => "lists#show"
end

Discourse::Application.routes.draw { mount ::DiscourseCustomTopicLists::Engine, at: "" }
