# frozen_string_literal: true

DiscourseCustomTopicLists::Engine.routes.draw { get "lists/:topic_list_name" => "lists#show" }

Discourse::Application.routes.draw { mount ::DiscourseCustomTopicLists::Engine, at: "" }
