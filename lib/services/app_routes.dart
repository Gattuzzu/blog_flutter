class AppRoutes {
  // Top-Level Routes (absolute Pfade)
  static const String home = "/";
  static const String blogOverview = "/blog";
  static const String addBlog = "/addBlog";
  static const String login = "/login";
  static const String secondScreen = "/secondScreen";
  static const String back = "back"; // Hilfsroute um sicher zurück zum letzten Screen zurück zu kommen.

  // Sub-Routes (relative Pfade)
  /* "/blog" */
  static const String blogDetail = "/:id"; // mit dem :id weiss GoRouter, dass dies eine Variable ist und die Variable id heisst. Dies wird benötigt, da es auch mehrere Variablen in einem Pfad geben könnte.

  // Helper-Methoden für Navigation
  static String toBlogDetail(int id) => '/blog/$id';
}