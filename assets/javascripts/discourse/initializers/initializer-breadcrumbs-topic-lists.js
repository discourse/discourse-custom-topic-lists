import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";
export default {
  name: "custom-topic-lists-initializer",
  initialize() {
    withPluginApi("0.8.12", (api) => {
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
            text = I18n.t("custom_topic_lists.sidebar");
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
