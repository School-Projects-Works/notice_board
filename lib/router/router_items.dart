class RouterItem {
  final String path;
  final String name;
  RouterItem({
    required this.path,
    required this.name,
  });

  static final RouterItem homeRoute = RouterItem(path: '/home', name: 'home');
  static final RouterItem loginRoute =
      RouterItem(path: '/login', name: 'login');
      static final RouterItem registerRoute =
      RouterItem(path: '/register', name: 'register');
  static final RouterItem forgotPasswordRoute =
      RouterItem(path: '/forgot-password', name: 'forgotPassword');
  static final RouterItem dashboardRoute =
      RouterItem(path: '/:id/dashboard', name: 'dashboard');
  static final RouterItem departmentsRoute =
      RouterItem(path: '/admin/departments', name: 'departmentsRoute');
  static final RouterItem noticeRoute =
      RouterItem(path: '/:id/notice', name: 'notice');
static List<RouterItem> allRoutes = [
    homeRoute,
    loginRoute,
    dashboardRoute,
    departmentsRoute,
    noticeRoute,
  ];

  static RouterItem getRouteByPath(String fullPath) {
    return allRoutes.firstWhere((element) => element.path == fullPath);
  }
}
