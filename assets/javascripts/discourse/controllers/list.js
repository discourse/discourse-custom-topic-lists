import { tracked } from "@glimmer/tracking";
import Controller from "@ember/controller";
import { action } from "@ember/object";

export default class extends Controller {
  @tracked q = "";
  @tracked model;

  queryParams = ["q"];

  @action
  updateTopicsListQueryParams(queryString) {
    this.q = queryString;
  }
}
