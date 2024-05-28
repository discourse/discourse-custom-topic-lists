import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action, computed } from "@ember/object";
import { service } from "@ember/service";
import ComboBox from "select-kit/components/combo-box";

export default class CustomTopicLists extends Component {
  @service siteSettings;
  @service router;

  @tracked value;
  @tracked
  content =
    JSON.parse(this.siteSettings.custom_topic_lists).map((t) => {
      t.id = t.path;
      return t;
    }) || [];

  constructor() {
    super(...arguments);
    if (this.router.currentRoute.params.topicListName) {
      this.value = this.router.currentRoute.params.topicListName;
    }
  }

  @computed("value")
  get comboBoxOptions() {
    return {
      filterable: true,
      none: this.value ? null : "custom_topic_lists_button.label",
      caretDownIcon: "caret-right",
      caretUpIcon: "caret-down",
    };
  }

  @action
  onInput(path) {
    this.value = path;
    this.router.transitionTo("list", path);
  }

  <template>
    <ComboBox
      @options={{this.comboBoxOptions}}
      @content={{this.content}}
      @value={{this.value}}
      @onChange={{this.onInput}}
    />
  </template>
}
