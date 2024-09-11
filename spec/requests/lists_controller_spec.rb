# frozen_string_literal: true

RSpec.describe "Lists controller" do
  let!(:admin) { Fabricate(:admin, name: "Admin") }
  let!(:user) { Fabricate(:user, name: "User") }
  fab!(:questions_category) { Fabricate(:category, name: "questions") }
  fab!(:arts_and_media_category) { Fabricate(:category, name: "arts-media") }
  fab!(:topic0) { Fabricate(:topic, category: questions_category) }
  fab!(:topic1) { Fabricate(:topic, category: arts_and_media_category) }

  class SiteSettingHelper
    def self.add_json(*jsons)
      jsons.each do |json|
        site_setting = JSON.parse SiteSetting.custom_topic_lists
        site_setting << json
        SiteSetting.custom_topic_lists = site_setting.to_json
      end
    end
  end

  before do
    SiteSetting.discourse_custom_topic_lists_enabled = true
    SiteSetting.experimental_topics_filter = true
    SiteSettingHelper.add_json(
      {
        "icon" => "question",
        "name" => "New questions",
        "description" => "Topic for new questions",
        "slug" => "some-long-path-for-questions",
        "query" => "category:questions",
        "showOnSidebar" => true,
        "showOnDropdown" => true,
        "access" => "admins",
      },
      {
        "icon" => "discourse-sparkles",
        "name" => "Arts and Media",
        "description" => "## Topic with categories related to arts and media",
        "slug" => "arts-and-media",
        "query" => "category:arts-media",
        "showOnSidebar" => true,
        "showOnDropdown" => true,
        "access" => "",
      },
      {
        "icon" => "discourse-sparkles",
        "name" => "Will not be shown in sidebar",
        "bannerLabel" => "Will not be shown in sidebar",
        "path" => "arts-and-media",
        "query" => "category:arts-media",
        "showOnSidebar" => false,
        "showOnDropdown" => true,
        "access" => "",
      },
      {
        "icon" => "discourse-sparkles",
        "name" => "Will not be shown in dropdown",
        "bannerLabel" => "Will not be shown in dropdown",
        "path" => "arts-and-media",
        "query" => "category:arts-media",
        "showOnSidebar" => true,
        "showOnDropdown" => false,
        "access" => "",
      },
    )
  end

  describe "GET /list/custom-topic-list.rss" do
    it "should return a list of custom topic lists same as `/filter`" do
      get "/filter.json?q=category:arts-media", headers: { "ACCEPT" => "application/json" } # same as the UI would do
      expect(response.status).to eq(200)
      json = response.parsed_body
      expect(json["topic_list"]["topics"].size).to eq(1)

      get "/l/arts-and-media.json"
      expect(response.status).to eq(200)
      expect(response.media_type).to eq("application/rss+xml")
      expect(response.body).to include("Arts and Media")
      expect(response.body).to include("## Topic with categories related to arts and media")
      expect(response.body).to include("arts-media")
    end
  end
end
