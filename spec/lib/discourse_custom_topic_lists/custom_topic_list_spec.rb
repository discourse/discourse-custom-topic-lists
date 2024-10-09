# frozen_string_literal: true

RSpec.describe DiscourseCustomTopicLists::CustomTopicList do
  fab!(:admin)
  fab!(:user)

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
    )
  end

  describe "#lists" do
    it "returns all custom lists for admins" do
      custom_lists = described_class.new(admin).lists
      expect(custom_lists.size).to eq(2)
    end

    it "returns only lists that the user has access to" do
      custom_lists = described_class.new(user).lists
      expect(custom_lists.size).to eq(1)
    end
  end

  describe "#find_by_slug" do
    it "returns the list with the given slug" do
      custom_list = described_class.new(admin).find_by_slug("arts-and-media")
      expect(custom_list["name"]).to eq("Arts and Media")
    end

    it "returns nil if the list does not exist" do
      custom_list = described_class.new(admin).find_by_slug("non-existent")
      expect(custom_list).to eq(nil)
    end

    it "returns the list which a user has access to" do
      slug = "some-long-path-for-questions"

      custom_list = described_class.new(admin).find_by_slug(slug)
      expect(custom_list["name"]).to eq("New questions")

      custom_list = described_class.new(user).find_by_slug(slug)
      expect(custom_list).to eq(nil)
    end
  end
end
