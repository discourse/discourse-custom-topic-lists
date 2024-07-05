import { tracked } from "@glimmer/tracking";
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { service } from "@ember/service";
import BulkSelectHelper from "discourse/lib/bulk-select-helper";

export default class ListController extends Controller {
  @service currentUser;
  @service modal;
  @service router;
  @tracked model;

  bulkSelectHelper = new BulkSelectHelper(this);

  get canBulkSelect() {
    return this.currentUser?.canManageTopic || this.showDismissRead;
  }

  get showDismissRead() {
    return this.model.topics.length > 0;
  }

  @action
  dismissRead(dismissTopics) {
    const operationType = dismissTopics ? "topics" : "posts";
    this.bulkSelectHelper.dismissRead(operationType);
  }
}
