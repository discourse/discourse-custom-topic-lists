# frozen_string_literal: true

RSpec.describe DiscourseCustomTopicLists::ListsController do
  fab!(:admin)
  fab!(:user)
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
      get "/lists/arts-and-media.rss"
      expect(response.status).to eq(200)
      expect(response.media_type).to eq("application/rss+xml")
      expected_rss = <<~RSS
        <?xml version="1.0" encoding="UTF-8" ?>
        <rss version="2.0" xmlns:discourse="http://www.discourse.org/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:dc="http://purl.org/dc/elements/1.1/">
          <channel>
            <title>Discourse - Arts and Media</title>
            <link>http://test.localhost/lists/arts-and-media</link>
            <description>## Topic with categories related to arts and media</description>
            <language>en</language>
              <lastBuildDate>#{topic1.created_at.rfc2822}</lastBuildDate>
              <atom:link href="http://test.localhost/lists/arts-and-media.rss" rel="self" type="application/rss+xml" />
                <item>
                  <title>This is a test topic 1</title>
                  <dc:creator><![CDATA[bruce5]]></dc:creator>
                  <category>arts-media</category>
                  <description><![CDATA[
                    <p><small>0 posts - 1 participant</small></p>
                    <p><a href="http://test.localhost/t/this-is-a-test-topic-1/#{topic1.id}">Read full topic</a></p>
                  ]]></description>
                  <link>http://test.localhost/t/this-is-a-test-topic-1/#{topic1.id}</link>
                  <pubDate>#{topic1.created_at.rfc2822}</pubDate>
                  <discourse:topicPinned>No</discourse:topicPinned>
                  <discourse:topicClosed>No</discourse:topicClosed>
                  <discourse:topicArchived>No</discourse:topicArchived>
                  <guid isPermaLink="false">test.localhost-topic-#{topic1.id}</guid>
                  <source url="http://test.localhost/t/this-is-a-test-topic-1/#{topic1.id}.rss">This is a test topic 1</source>
                </item>
          </channel>
        </rss>
      RSS
      expect(response.body).to eq(expected_rss)
    end
  end
end
