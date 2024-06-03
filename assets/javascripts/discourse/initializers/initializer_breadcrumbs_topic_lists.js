import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";
export default {
  name: "custom-topic-lists-initializer",
  initialize() {
    withPluginApi("0.8.12", (api) => {
      const user = api.getCurrentUser();
      api.addSidebarSection(
        (BaseCustomSidebarSection, BaseCustomSidebarSectionLink) => {
          return class extends BaseCustomSidebarSection {
            get name() {
              return "custom-topic-lists";
            }

            get route() {
              return "chat";
            }

            get title() {
              return "Fooo";
            }

            get text() {
              return I18n.t("custom_topic_lists_button.label");
            }

            get links() {
              return user.custom_topic_lists
                .filter(({ showOnSidebar }) => showOnSidebar)
                .map(({ access, icon, name, path }) => {
                  return new (class extends BaseCustomSidebarSectionLink {
                    get name() {
                      return name;
                    }
                    get route() {
                      return "list";
                    }
                    get models() {
                      return [path];
                    }
                    get title() {
                      return name;
                    }
                    get text() {
                      return name;
                    }
                    get prefixType() {
                      return "icon";
                    }
                    get prefixValue() {
                      return icon;
                    }
                    get prefixBadge() {
                      return access === "private" ? "lock" : null;
                    }
                  })();
                });
            }
          };
        }
      );
    });
  },
};
