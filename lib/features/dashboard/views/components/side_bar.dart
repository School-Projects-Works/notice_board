import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../router/router.dart';
import '../../../../router/router_items.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import '../../../auth/provider/user_provider.dart';
import 'side_bar_item.dart';

class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    var user = ref.watch(userProvider);
    return Container(
        width: 200,
        height: styles.height,
        color: primaryColor,
        child: Column(children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(
                    text: 'Hello, \n',
                    style: styles.body(
                      color: Colors.white38,
                    ),
                    children: [
                  TextSpan(
                      text: ref.watch(userProvider).name,
                      style: styles.subtitle(
                        fontWeight: FontWeight.bold,
                        fontSize: styles.isDesktop ? 20 : 16,
                        color: Colors.white,
                      ))
                ])),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: user.role == 'admin'
                ? buildAdminManu(ref, context)
                : user.role == 'secretary'
                    ? buildManagerManu(ref, context)
                    : buildUserManu(ref, context),
          ),
          // footer
          Text('© 2024 All rights reserved',
              style: styles.body(color: Colors.white38, fontSize: 12)),
        ]));
  }

  Widget buildAdminManu(WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        SideBarItem(
          title: 'Dashboard',
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          icon: Icons.dashboard,
          isActive: ref.watch(routerProvider) == RouterItem.dashboardRoute.name,
          onTap: () {
            MyRouter(context: context, ref: ref)
                .navigateToRoute(RouterItem.dashboardRoute);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Affiliations',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.hotel,
            isActive:
                ref.watch(routerProvider) == RouterItem.departmentsRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.departmentsRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Secretaries',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.people,
            isActive:
                ref.watch(routerProvider) == RouterItem.secretariesRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.secretariesRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Notice',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.notifications,
            isActive: ref.watch(routerProvider) == RouterItem.noticeRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.noticeRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Students',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.people,
            isActive:
                ref.watch(routerProvider) == RouterItem.studentsRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.studentsRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Requests',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.request_page,
            isActive: ref.watch(routerProvider) == RouterItem.requestRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.requestRoute);
            },
          ),
        ),
      ],
    );
  }

  Widget buildUserManu(WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'My Notice',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.notifications,
            isActive: ref.watch(routerProvider) == RouterItem.noticeRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.noticeRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'My Requests',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.request_page,
            isActive: ref.watch(routerProvider) == RouterItem.requestRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.requestRoute);
            },
          ),
        ),
        //profile
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Profile',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.person,
            isActive: ref.watch(routerProvider) == RouterItem.profileRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.profileRoute);
            },
          ),
        ),
      ],
    );
  }

  Widget buildManagerManu(WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        SideBarItem(
          title: 'Dashboard',
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          icon: Icons.dashboard,
          isActive: ref.watch(routerProvider) == RouterItem.dashboardRoute.name,
          onTap: () {
            MyRouter(context: context, ref: ref)
                .navigateToRoute(RouterItem.dashboardRoute);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Notice',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.notifications,
            isActive: ref.watch(routerProvider) == RouterItem.noticeRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.noticeRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Students',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.people,
            isActive:
                ref.watch(routerProvider) == RouterItem.studentsRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.studentsRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Requests',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.request_page,
            isActive: ref.watch(routerProvider) == RouterItem.requestRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.requestRoute);
            },
          ),
        ),
        //profile
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Profile',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.person,
            isActive: ref.watch(routerProvider) == RouterItem.profileRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.profileRoute);
            },
          ),
        ),
      ],
    );
  }
}
