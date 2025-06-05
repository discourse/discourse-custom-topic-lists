import RouteTemplate from "ember-route-template";
import DNavigation from "discourse/components/d-navigation";
import Layout from "discourse/components/discovery/layout";
import Topics from "discourse/components/discovery/topics";
import bodyClass from "discourse/helpers/body-class";
import concatClass from "discourse/helpers/concat-class";

export default RouteTemplate(
  <template>
    {{bodyClass (concatClass "custom-list-body" @controller.model.path)}}
    <Layout @model={{@controller.model}}>
      <:navigation>
        <section class="navigation-container">
          <DNavigation @model={{@model}} />
        </section>

      </:navigation>
      <:list>
        <Topics
          @model={{@controller.model}}
          @canBulkSelect={{@controller.canBulkSelect}}
          @bulkSelectHelper={{@controller.bulkSelectHelper}}
          @showDismissRead={{@controller.showDismissRead}}
          @dismissRead={{@controller.dismissRead}}
        />
      </:list>
    </Layout>
  </template>
);
