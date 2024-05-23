import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import DiscourseRoute from "discourse/routes/discourse";

export default class DiscoveryFilterRoute extends DiscourseRoute {
  @service site;
  @service router;

  queryParams = {
    q: { replace: true, refreshModel: true },
  };

  async model(data) {
    const topicList = this.#resolveTopicList(data.topicListName);
    if (!topicList) {
      return this.router.replaceWith("/404");
    }

    const list = await this.store.findFiltered("topicList", {
      filter: "filter",
      params: { q: topicList.query },
    });
    list.set("title", topicList.title);

    return list;
  }

  setupController(_controller, model) {
    this.controllerFor("discovery/topics").setProperties({ model });
  }

  renderTemplate() {
    this.render("custom-topic-lists/header", { outlet: "navigation-bar" });

    this.render("discovery/topics", {
      controller: "discovery/topics",
      outlet: "list-container",
    });
  }

  @action
  changeSort() {}

  @action
  changeNewListSubset() {}

  #resolveTopicList(name) {
    return this.site.custom_topic_lists.find((list) => list.path === name);
  }
}
