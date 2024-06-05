# frozen_string_literal: true

RSpec.describe "Preset Topic Composer | preset topic creation", type: :system do
  let!(:admin) { Fabricate(:admin, name: "Admin") }
  fab!(:questions_category) { Fabricate(:category, name: "questions") }
  fab!(:arts_and_media_category) { Fabricate(:category, name: "arts-media") }
  fab!(:topic0) { Fabricate(:topic, category: questions_category) }
  fab!(:topic1) { Fabricate(:topic, category: arts_and_media_category) }

  before do
    SiteSetting.discourse_custom_topic_lists_enabled = true
    SiteSetting.experimental_topics_filter = true
    sign_in(admin)
  end

  describe "with plugin enabled" do
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
      expect(list).to have_text(I18n.t("custom_topic_lists_button.label"))

      find("li[data-list-item-name='New questions']").click
      expect(page).to have_text(topic0.title)

      find("li[data-list-item-name='Arts and Media']").click
      expect(page).to have_text(topic1.title)
    end

    it "should be able to see topic banner in custom topic list" do
      visit "/"

      find("li[data-list-item-name='Arts and Media']").click

      expect(page).to have_text(topic1.title)

      category_banner_label =
        "Topic with categories related to arts and media and some more text so that it should break a line and we could see"

      expect(page).to have_text(category_banner_label)
    end
  end
end
