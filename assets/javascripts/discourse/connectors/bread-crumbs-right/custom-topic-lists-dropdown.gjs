import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action, computed } from "@ember/object";
import didUpdate from "@ember/render-modifiers/modifiers/did-update";
import { service } from "@ember/service";
import ComboBox from "select-kit/components/combo-box";

export default class CustomTopicLists extends Component {
  @service router;
  @service currentUser;

  @tracked value;
  @tracked
  content =
    this.currentUser.custom_topic_lists.map((t) => {
      t.id = t.path;
      return t;
    }) || [];

  constructor() {
    super(...arguments);
    this.maybeUpdateValue();
  }

  @action
  maybeUpdateValue() {
    if (this.router.currentRoute.params.topicListName) {
      this.value = this.router.currentRoute.params.topicListName;
    }
  }

  @computed("comboBoxOptions")
  get comboBoxOptions() {
    return {
      filterable: true,
      none: "custom_topic_lists_button.label",
      caretDownIcon: "caret-right",
      caretUpIcon: "caret-down",
      headerComponent: "tag-drop/tag-drop-header",
      autoInsertNoneItem: false,
      allowAny: false,
      fullWidthOnMobile: true,
    };
  }

  @action
  onInput(path) {
    this.value = path;
    this.router.transitionTo("list", path);
  }

  <template>
    <li {{didUpdate this.maybeUpdateValue this.router.currentRoute}}>
      <ComboBox
        @options={{this.comboBoxOptions}}
        @content={{this.content}}
        @value={{this.value}}
        @onChange={{this.onInput}}
        class="tag-drop list-drop"
      />
    </li>
  </template>
}
