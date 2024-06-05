import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didUpdate from "@ember/render-modifiers/modifiers/did-update";
import { service } from "@ember/service";

export default class CustomTopicListsBanner extends Component {
  @service router;
  @service currentUser;

  get customTopic() {
    if (!this.router.currentRoute.params.topicListName) {
      return;
    }

    this.customTopic = this.currentUser.custom_topic_lists.find(
      (list) => list.path === this.router.currentRoute.params.topicListName
    );
  }

  get shouldShow() {
    return this.customTopic;
  }

  <template>
    <div {{didUpdate this.maybeUpdateCustomTopic this.router.currentRoute}}>
      {{#if this.shouldShow}}
        <div class="custom-list-banner banner-color">
          <div class="custom-list-banner-contents">
            <h1>{{this.customTopic.name}}</h1>
            <p>{{this.customTopic.bannerLabel}}</p>
          </div>
        </div>
      {{/if}}
    </div>
  </template>
}
