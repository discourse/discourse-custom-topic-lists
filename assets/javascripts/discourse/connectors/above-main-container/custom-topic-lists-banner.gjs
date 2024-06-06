import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class CustomTopicListsBanner extends Component {
  @service router;
  @service currentUser;

  get customTopic() {
    if (!this.router.currentRoute.params.topicListName) {
      return;
    }

    return this.currentUser.custom_topic_lists.find(
      (list) => list.path === this.router.currentRoute.params.topicListName
    );
  }

  <template>
    {{#if this.customTopic}}
      <div class="custom-list-banner banner-color">
        <div class="custom-list-banner-contents">
          <h1>{{this.customTopic.name}}</h1>
          <p>{{this.customTopic.bannerLabel}}</p>
        </div>
      </div>
    {{/if}}
  </template>
}