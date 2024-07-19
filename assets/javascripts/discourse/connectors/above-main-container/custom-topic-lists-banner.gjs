import Component from "@glimmer/component";
import { service } from "@ember/service";
import CookText from "discourse/components/cook-text";
import bodyClass from "discourse/helpers/body-class";
import icon from "discourse-common/helpers/d-icon";

export default class CustomTopicListsBanner extends Component {
  @service router;
  @service site;

  get customTopic() {
    if (!this.router.currentRoute.params.topicListName) {
      return;
    }

    return this.site.custom_topic_lists.find(
      (list) => list.slug === this.router.currentRoute.params.topicListName
    );
  }

  <template>
    {{#if this.customTopic}}
      {{! These classes are reflection of discourse-category-banners at category-banner.hbs }}
      {{! https://github.com/discourse/discourse-category-banners/javascripts/discourse/components/category-banner.hbs }}
      {{bodyClass "category-header"}}
      <div class="category-title-header">
        <div class="category-title-contents">
          <div class="category-logo aspect-image"></div>
          <h1 class="category-title">
            {{#if this.customTopic.icon}}
              <div class="category-icon-widget-wrapper">
                <div class="category-icon-widget">
                  <span class="category-icon">{{icon
                      this.customTopic.icon
                    }}</span>
                </div>
              </div>
            {{/if}}
            {{this.customTopic.name}}
          </h1>
          <div class="category-title-description">
            <CookText @rawText={{this.customTopic.description}} />
          </div>
        </div>
      </div>
    {{/if}}
  </template>
}
