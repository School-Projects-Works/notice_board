import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notice_board/features/auth/views/registration_page.dart';
import 'package:notice_board/features/dashboard/pages/notices/views/notices_page.dart';
import 'package:notice_board/features/dashboard/pages/request/views/request_page.dart';
import 'package:notice_board/features/dashboard/pages/request/views/view_request.dart';
import 'package:notice_board/features/home/views/home_page.dart';
import 'package:notice_board/router/router_items.dart';

import '../features/auth/views/forget_password_page.dart';
import '../features/auth/views/login_page.dart';
import '../features/dashboard/pages/affiliations/views/affiliations_page.dart';
import '../features/dashboard/pages/home/views/dashboard_home.dart';
import '../features/dashboard/pages/notices/views/view_notice.dart';
import '../features/dashboard/pages/profile/views/profile_page.dart';
import '../features/dashboard/pages/secretaries/views/secretaries_page.dart';
import '../features/dashboard/pages/students/views/students_pages.dart';
import '../features/dashboard/views/dashboard_main.dart';
import '../features/home/views/components/notice_details_page.dart';
import '../features/main/views/container_page.dart';

class MyRouter {
  final WidgetRef ref;
  final BuildContext context;
  MyRouter({
    required this.ref,
    required this.context,
  });
  router() => GoRouter(
          initialLocation: RouterItem.homeRoute.path,
          redirect: (context, state) {
            var route = state.fullPath;
            //check if widget is done building
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (route != null && route.isNotEmpty) {
                var item = RouterItem.getRouteByPath(route);
                ref.read(routerProvider.notifier).state = item.name;
              }
            });
            return null;
          },
          routes: [
            ShellRoute(
                builder: (context, state, child) {
                  return ContainerPage(
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                      path: RouterItem.homeRoute.path,
                      builder: (context, state) {
                        return const HomePage();
                      }),
                  GoRoute(
                      path: RouterItem.loginRoute.path,
                      builder: (context, state) {
                        return const LoginPage();
                      }),
                  GoRoute(
                      path: RouterItem.registerRoute.path,
                      builder: (context, state) {
                        return const RegistrationPage();
                      }),
                  GoRoute(
                      path: RouterItem.forgotPasswordRoute.path,
                      builder: (context, state) {
                        return const ForgetPasswordPage();
                      }),
                  GoRoute(
                      path: RouterItem.noticeDetailsRoute.path,
                      name: RouterItem.noticeDetailsRoute.name,
                      builder: (context, state) {
                        var noticeId = state.pathParameters['noticeId'];
                        return NoticeDetailsPage(noticeId: noticeId!);
                      }),
                ]),
            ShellRoute(
                builder: (context, state, child) {
                  return DashBoardMainPage(
                    child,
                  );
                },
                routes: [
                  GoRoute(
                      path: RouterItem.dashboardRoute.path,
                      builder: (context, state) {
                        return const DashboardHomePage();
                      }),
                  GoRoute(
                      path: RouterItem.profileRoute.path,
                      builder: (context, state) {
                        return const ProfilePage();
                      }),
                  GoRoute(
                      path: RouterItem.secretariesRoute.path,
                      builder: (context, state) {
                        return const SecretariesPage();
                      }),
                  GoRoute(
                      path: RouterItem.noticeRoute.path,
                      builder: (context, state) {
                        return const NoticesPage();
                      }),
                  GoRoute(
                      path: RouterItem.requestRoute.path,
                      builder: (context, state) {
                        return const RequestPage();
                      }),
                  GoRoute(
                      path: RouterItem.studentsRoute.path,
                      builder: (context, state) {
                        return const StudentsPages();
                      }),
                  GoRoute(
                      path: RouterItem.departmentsRoute.path,
                      builder: (context, state) {
                        return const AffiliationsPage();
                      }),
                  GoRoute(
                      path: RouterItem.dashNoticeDetailsRoute.path,
                      name: RouterItem.dashNoticeDetailsRoute.name,
                      builder: (context, state) {
                        var noticeId = state.pathParameters['noticeId'];
                        return ViewNotice(noticeId: noticeId!);
                      }),
                  GoRoute(
                      path: RouterItem.viewRequestRoute.path,
                      name: RouterItem.viewRequestRoute.name,
                      builder: (context, state) {
                        var id = state.pathParameters['id'];
                        return ViewRequest(id!);
                      }),
                ])
          ]);

  void navigateToRoute(RouterItem item) {
    ref.read(routerProvider.notifier).state = item.name;
    context.go(item.path);
  }

  void navigateToNamed(
      {required Map<String, String> pathPrams,
      required RouterItem item,
      Map<String, dynamic>? extra}) {
    ref.read(routerProvider.notifier).state = item.name;
    context.goNamed(item.name, pathParameters: pathPrams, extra: extra);
  }
}

final routerProvider = StateProvider<String>((ref) {
  return RouterItem.homeRoute.name;
});
