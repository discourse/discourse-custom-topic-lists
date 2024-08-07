import { service } from "@ember/service";
import DiscourseRoute from "discourse/routes/discourse";

export default class List extends DiscourseRoute {
  @service site;
  @service router;
  @service store;

  async model(data) {
    const topicList = this.site.custom_topic_lists.find(
      (list) => list.slug === data.topicListName
    );
    if (!topicList) {
      return this.router.replaceWith("/404");
    }
    const list = await this.store.findFiltered("topicList", {
      filter: "filter",
      params: { q: topicList.query },
    });
    list.set("path", topicList.slug);
    return list;
  }
}
