import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";

export default {
  name: "custom-topic-lists-initializer",
  initialize() {
    withPluginApi((api) => {
      const site = api.container.lookup("service:site");
      if (!site.custom_topic_lists || site.custom_topic_lists.length === 0) {
        return;
      }
      const customTopicsToShow = site.custom_topic_lists.filter(
        ({ showOnSidebar }) => showOnSidebar
      );
      if (customTopicsToShow.length === 0) {
        return;
      }
      api.addSidebarSection(
        (BaseCustomSidebarSection, BaseCustomSidebarSectionLink) => {
          return class extends BaseCustomSidebarSection {
            name = "custom-topic-lists";
            text = i18n("custom_topic_lists.sidebar");
            links = customTopicsToShow.map(({ icon, name, slug }) => {
              return new (class extends BaseCustomSidebarSectionLink {
                name = name;
                route = "list";
                models = [slug];
                title = name;
                text = name;
                prefixType = "icon";
                prefixValue = icon;
              })();
            });
          };
        }
      );
    });
  },
};
