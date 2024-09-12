# frozen_string_literal: true

DiscourseCustomTopicLists::Engine.routes.draw do
  get "list/:topic_list_name",
      to: redirect { |params, request| "lists/#{params[:topic_list_name]}" }

  get "l/:topic_list_name.rss" => "lists#lists_feed", :format => :rss

  get "lists/:topic_list_name" => "lists#show"
end
