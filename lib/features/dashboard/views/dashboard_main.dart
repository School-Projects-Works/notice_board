import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/features/dashboard/pages/request/provider/request_provider.dart';
import 'package:notice_board/features/dashboard/pages/secretaries/provider/secretaries_provider.dart';
import 'package:notice_board/features/dashboard/pages/students/provider/students_provider.dart';
import 'package:notice_board/features/notice/provider/notice_provider.dart';
import 'package:notice_board/generated/assets.dart';
import '../../../core/views/custom_dialog.dart';
import '../../../router/router.dart';
import '../../../router/router_items.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';
import '../../auth/provider/user_provider.dart';
import '../../main/components/app_bar_item.dart';
import '../pages/affiliations/provider/dash_affi_provider.dart';
import 'components/side_bar.dart';

class DashBoardMainPage extends ConsumerWidget {
  const DashBoardMainPage(this.child, {super.key});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    var user = ref.watch(userProvider);
    var userStream = ref.watch(secretariesStream);
    var noticeStream = ref.watch(noticeListStream);
    var affiliationStream = ref.watch(dashAffiStreamProvider);
    var studentsStream = ref.watch(studentsStreamProvider);
    var requestStream = ref.watch(requestStreamProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            actions: [
              const SizedBox(width: 10),
              PopupMenuButton(
                  color: primaryColor,
                  offset: const Offset(0, 70),
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    backgroundImage: () {
                      var user = ref.watch(userProvider);
                      if (user.image == null) {
                        return const AssetImage(Assets.imagesProfile);
                      } else {
                        NetworkImage(user.image!);
                      }
                    }(),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: BarItem(
                            padding: const EdgeInsets.only(
                                right: 40, top: 10, bottom: 10, left: 10),
                            icon: Icons.home,
                            title: 'Home Page',
                            onTap: () {
                              MyRouter(context: context, ref: ref)
                                  .navigateToRoute(RouterItem.homeRoute);
                              Navigator.of(context).pop();
                            }),
                      ),
                      PopupMenuItem(
                        child: BarItem(
                            padding: const EdgeInsets.only(
                                right: 40, top: 10, bottom: 10, left: 10),
                            icon: Icons.logout,
                            title: 'Logout',
                            onTap: () {
                              CustomDialogs.showDialog(
                                message: 'Are you sure you want to logout?',
                                type: DialogType.info,
                                secondBtnText: 'Logout',
                                onConfirm: () {
                                  ref
                                      .read(userProvider.notifier)
                                      .logout(context: context, ref: ref);
                                  Navigator.of(context).pop();
                                },
                              );
                            }),
                      ),
                    ];
                  }),
              const SizedBox(width: 10),
            ],
            title: Row(
              children: [
                Image.asset(
                  Assets.imagesLogoT,
                  height: 40,
                ),
                const SizedBox(width: 10),
                if (styles.smallerThanTablet)
                  //manu button
                  if (user.role.toLowerCase() == 'admin')
                    buildAdminManu(ref, context)
                  else if (user.role.toLowerCase() == 'secretary')
                    buildManagerManu(ref, context)
                  else if (user.role.toLowerCase() == 'student')
                    buildStudentManu(ref, context)
              ],
            ),
          ),
          body: Container(
            color: Colors.white60,
            padding: const EdgeInsets.all(4),
            child: styles.smallerThanTablet
                ? child
                : Row(
                    children: [
                      const SideBar(),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                              color: Colors.grey[100],
                              padding: const EdgeInsets.all(10),
                              child: affiliationStream.when(
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (error, stack) {
                                  return Center(child: Text(error.toString()));
                                },
                                data: (data) {
                                  return userStream.when(
                                      data: (user) {
                                        return noticeStream.when(
                                            data: (notice) {
                                              return studentsStream.when(
                                                data: (students) {
                                                  return requestStream.when(
                                                      data: (data){

                                                  return child;
                                                      },
                                                      error: (error,stack){
                                                        return Center(child: Text(error.toString()));
                                                      },
                                                      loading: () => const Center(child: CircularProgressIndicator())); 
                                                },
                                                error: (error, stack) {
                                                  return Center(
                                                      child: Text(
                                                          error.toString()));
                                                },
                                                loading: () => const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              );
                                            },
                                            error: (error, stack) {
                                              return Center(
                                                  child:
                                                      Text(error.toString()));
                                            },
                                            loading: () => const Center(
                                                child:
                                                    CircularProgressIndicator()));
                                      },
                                      error: (error, stack) {
                                        return Center(
                                            child: Text(error.toString()));
                                      },
                                      loading: () => const Center(
                                          child: CircularProgressIndicator()));
                                },
                              )))
                    ],
                  ),
          )),
    );
  }

  Widget buildAdminManu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
      color: primaryColor,
      offset: const Offset(0, 70),
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.dashboard,
                title: 'Dashboard',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.dashboardRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.hotel,
                title: 'Affiliations',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.departmentsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.people,
                title: 'Secretaries',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.secretariesRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.people,
                title: 'Students',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.studentsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.notifications,
                title: 'Notice',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.noticeRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.request_page,
                title: 'Requests',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.requestRoute);
                  Navigator.of(context).pop();
                }),
          ),
        ];
      },
    );
  }

  Widget buildManagerManu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
        color: primaryColor,
        offset: const Offset(0, 70),
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.dashboardRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.notifications,
                  title: 'Notice',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.noticeRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.request_page,
                  title: 'Requests',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.requestRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            // complainst
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.profileRoute);
                    Navigator.of(context).pop();
                  }),
            ),
          ];
        });
  }

  Widget buildStudentManu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
        color: primaryColor,
        offset: const Offset(0, 70),
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.notifications,
                  title: 'My Notice',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.noticeRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.profileRoute);
                    Navigator.of(context).pop();
                  }),
            ),
          ];
        });
  }
}
