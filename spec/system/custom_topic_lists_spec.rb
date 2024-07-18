# frozen_string_literal: true

RSpec.describe "Custom Topic Lists | custom lists access", type: :system do
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

  describe "with plugin enabled" do
    context "as an admin" do
      before { sign_in(admin) }
      it "should be able to access custom topic lists in the dropdown" do
        visit "/"
        expect(page).to have_selector(".list-drop")

        find(".list-drop").click
        find("li[title='New questions']").click

        expect(page).to have_text("New questions")
        expect(page).to have_text(topic0.title)

        visit "/lists/arts-and-media"
        expect(page).to have_selector(".list-drop")

        expect(page).to have_text("Arts and Media")
        expect(page).to have_text(topic1.title)
      end

      it "should be able to access custom topic lists in the sidebar" do
        visit "/"

        list = find("div[data-section-name='custom-topic-lists']")
        expect(list).to have_text(I18n.t("custom_topic_lists.sidebar"))

        find("li[data-list-item-name='New questions']").click
        expect(page).to have_text(topic0.title)

        find("li[data-list-item-name='Arts and Media']").click
        expect(page).to have_text(topic1.title)
      end

      it "should be able to see topic banner in custom topic list" do
        visit "/"

        find("li[data-list-item-name='Arts and Media']").click

        expect(page).to have_text(topic1.title)

        category_banner_label = "Topic with categories related to arts and media"

        expect(page).to have_text(category_banner_label)
      end

      it "should not be able to see custom topic lists that are not shown in sidebar" do
        visit "/"
        expect(page).to have_text("New questions")
        expect(page).to have_text("Arts and Media")
        expect(page).not_to have_text("Will not be shown in sidebar")
      end

      it "should not be able to see custom topic lists that are not shown in dropdown" do
        visit "/"
        expect(page).to have_selector(".list-drop")
        find("div[data-section-name='custom-topic-lists']").find(".btn").click # close sidebar
        find(".list-drop").click
        expect(page).to have_text("New questions")
        expect(page).to have_text("Arts and Media")
        expect(page).not_to have_text("Will not be shown in dropdown")
      end

      it "should be able to bulk select topics in custom topic lists" do
        SiteSetting.experimental_topic_bulk_actions_enabled_groups = "1"
        visit "/"
        find("li[data-list-item-name='Arts and Media']").click
        expect(page).to have_css(".bulk-select")
      end
    end

    context "as a non-admin" do
      before { sign_in(user) }
      it "should not be able to access custom topic lists in the dropdown" do
        visit "/"
        expect(page).to have_selector(".list-drop")
        find(".list-drop").click
        expect(page).not_to have_text("New questions")
        expect(page).to have_text("Arts and Media")
      end
    end

    context "as a non-logged-in user" do
      it "should be able to see custom topic lists dropdown" do
        visit "/"
        expect(page).to have_selector(".list-drop")
      end
    end
  end
end
