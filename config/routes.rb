# frozen_string_literal: true

DiscourseCustomTopicLists::Engine.routes.draw do
   get "lists/:topic_list_name" => "lists#show"
end

Discourse::Application.routes.draw do
  mount ::DiscourseCustomTopicLists::Engine, at: "custom-topic-lists"
end
