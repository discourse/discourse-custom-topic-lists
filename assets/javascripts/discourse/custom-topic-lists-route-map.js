export default function () {
  this.route("discovery", { path: "/", resetNamespace: true }, function () {
    this.route("list", { path: "/lists/*topicListName", resetNamespace: true });
  });
}
