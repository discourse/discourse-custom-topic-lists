import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";
export default {
  name: "custom-topic-lists-initializer",
  initialize() {
    withPluginApi("0.8.12", (api) => {
      const user = api.getCurrentUser();
      if (!user) {
        return;
      }
      if (!user.custom_topic_lists || user.custom_topic_lists.length === 0) {
        return;
      }
      const customTopicsToShow = user.custom_topic_lists.filter(
        ({ showOnSidebar }) => showOnSidebar
      );
      if (customTopicsToShow.length === 0) {
        return;
      }
      api.addSidebarSection(
        (BaseCustomSidebarSection, BaseCustomSidebarSectionLink) => {
          return class extends BaseCustomSidebarSection {
            name = "custom-topic-lists";
            text = I18n.t("custom_topic_lists_button.label");
            links = customTopicsToShow.map(({ icon, name, path }) => {
              return new (class extends BaseCustomSidebarSectionLink {
                name = name;
                route = "list";
                models = [path];
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
