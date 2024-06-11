import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import ComboBox from "select-kit/components/combo-box";

export default class CustomTopicListsDropdown extends Component {
  @service router;
  @service currentUser;

  comboBoxOptions = {
    filterable: true,
    none: "custom_topic_lists.dropdown",
    caretDownIcon: "caret-right",
    caretUpIcon: "caret-down",
    headerComponent: "tag-drop/tag-drop-header",
    autoInsertNoneItem: false,
    allowAny: false,
    fullWidthOnMobile: true,
  };

  content =
    this.currentUser?.custom_topic_lists
      .filter(({ showOnDropdown }) => showOnDropdown)
      .map((t) => {
        t.id = t.slug;
        return t;
      }) || [];

  get value() {
    if (!this.router.currentRoute.params.topicListName) {
      return;
    }

    return this.currentUser.custom_topic_lists.find(
      (list) => list.slug === this.router.currentRoute.params.topicListName
    ).slug;
  }

  @action
  onInput(slug) {
    this.router.transitionTo("list", slug);
  }

  <template>
    {{#if this.currentUser.custom_topic_lists.length}}
      <li class="last-item">
        <ComboBox
          @options={{this.comboBoxOptions}}
          @content={{this.content}}
          @value={{this.value}}
          @onChange={{this.onInput}}
          class="tag-drop list-drop"
        />
      </li>
    {{/if}}
  </template>
}
