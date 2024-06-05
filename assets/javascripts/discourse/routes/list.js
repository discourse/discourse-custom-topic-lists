import { action } from "@ember/object";
import { service } from "@ember/service";
import DiscourseRoute from "discourse/routes/discourse";

export default class DiscoveryFilterRoute extends DiscourseRoute {
  @service site;
  @service siteSettings;
  @service router;

  async model(data) {
    const topicList = this.#resolveTopicList(data.topicListName);
    if (!topicList) {
      return this.router.replaceWith("/404");
    }
    const list = await this.store.findFiltered("topicList", {
      filter: "filter",
      params: { q: topicList.query },
    });
    return list;
  }

  @action
  changeSort() {}

  @action
  changeNewListSubset() {}

  #resolveTopicList(path) {
    return this.currentUser.custom_topic_lists.find(
      (list) => list.path === path
    );
  }
}
