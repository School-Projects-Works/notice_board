import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/views/custom_dialog.dart';
import '../../../generated/assets.dart';
import '../../../router/router.dart';
import '../../../router/router_items.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart';
import '../../auth/provider/user_provider.dart';
import 'app_bar_item.dart';

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    var user = ref.watch(userProvider);
    return Container(
      width: double.infinity,
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Logo
          Image.asset(Assets.imagesLogoT, height: 45),
          const SizedBox(width: 20),
          const Spacer(),
          // Hamburger
          if (styles.smallerThanTablet)
            PopupMenuButton(
              color: primaryColor,
              offset: const Offset(0, 70),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: BarItem(
                      padding: const EdgeInsets.only(
                          right: 40, top: 10, bottom: 10, left: 10),
                      title: 'Home',
                      onTap: () {
                        MyRouter(ref: ref, context: context)
                            .navigateToRoute(RouterItem.homeRoute);
                        Navigator.of(context).pop();
                      },
                      isActive: ref.watch(routerProvider) ==
                          RouterItem.homeRoute.name,
                      icon: Icons.home),
                ),
                if (ref.watch(userProvider).id.isEmpty)
                  PopupMenuItem(
                    child: BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Login',
                        onTap: () {
                          MyRouter(ref: ref, context: context)
                              .navigateToRoute(RouterItem.loginRoute);
                          Navigator.of(context).pop();
                        },
                        isActive: ref.watch(routerProvider) ==
                            RouterItem.loginRoute.name,
                        icon: Icons.login),
                  ),
                if (user.id.isNotEmpty)
                  PopupMenuItem(
                    child: BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Dashboard',
                        onTap: () {
                          if(user.role=='student') {
                            MyRouter(ref: ref, context: context)
                              .navigateToRoute(RouterItem.noticeRoute);
                          }else{
                            MyRouter(ref: ref, context: context)
                              .navigateToRoute(RouterItem.dashboardRoute);
                          }
                          Navigator.of(context).pop();
                        },
                        isActive: ref.watch(routerProvider) ==
                            RouterItem.dashboardRoute.name,
                        icon: Icons.dashboard),
                  ),
                if (ref.watch(userProvider).id.isNotEmpty)
                  PopupMenuItem(
                    child: BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Logout',
                        onTap: () {
                          CustomDialogs.showDialog(
                            message: 'Are you sure you want to logout?',
                            type: DialogType.info,
                            secondBtnText: 'Logout',
                            onConfirm: () {
                              ref.read(userProvider.notifier).logout(
                                    context: context,ref: ref,
                                  );
                              //close popup
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        icon: Icons.logout),
                  ),
              ],
              icon: const Icon(Icons.menu, color: Colors.white),
            )
          else
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BarItem(
                  title: 'Home',
                  onTap: () {
                    MyRouter(ref: ref, context: context)
                        .navigateToRoute(RouterItem.homeRoute);
                  },
                  isActive:
                      ref.watch(routerProvider) == RouterItem.homeRoute.name,
                ),

                const SizedBox(width: 20),
               
                ref.watch(userProvider).id.isEmpty
                    ? BarItem(
                        padding: const EdgeInsets.only(
                            right: 40, top: 10, bottom: 10, left: 10),
                        title: 'Login',
                        onTap: () {
                          MyRouter(ref: ref, context: context)
                              .navigateToRoute(RouterItem.loginRoute);
                        },
                        isActive: ref.watch(routerProvider) ==
                            RouterItem.loginRoute.name,
                      )
                    : PopupMenuButton(
                        color: primaryColor,
                        offset: const Offset(0, 70),
                        child: CircleAvatar(
                          backgroundColor: secondaryColor,
                          backgroundImage: () {
                            var user = ref.watch(userProvider);
                            if (user.image == null) {
                              return const AssetImage(                                
                               Assets.imagesProfile,
                              );
                            } else {
                              NetworkImage(
                                user.image!,
                                scale: 0.1,
                              );
                            }
                          }(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ref.watch(userProvider).image != null
                                ? Image.network(ref.watch(userProvider).image!)
                                : null,
                          ),
                        ),
                        itemBuilder: (context) {
                          return [
                            //dashboard
                            PopupMenuItem(
                              child: BarItem(
                                padding: const EdgeInsets.only(
                                    right: 40, top: 10, bottom: 10, left: 10),
                                title: 'Dashboard',
                                icon: Icons.dashboard,
                                onTap: () {
                                  if(user.role=='student') {
                                    MyRouter(ref: ref, context: context)
                                      .navigateToRoute(RouterItem.noticeRoute);
                                  }else{
                                  MyRouter(ref: ref, context: context)
                                      .navigateToRoute(
                                          RouterItem.dashboardRoute);
                                  }
                                  Navigator.of(context).pop();
                                },
                                isActive: ref.watch(routerProvider) ==
                                    RouterItem.dashboardRoute.name,
                              ),
                            ),

                            PopupMenuItem(
                              child: BarItem(
                                  padding: const EdgeInsets.only(
                                      right: 40, top: 10, bottom: 10, left: 10),
                                  icon: Icons.logout,
                                  title: 'Logout',
                                  onTap: () {
                                    CustomDialogs.showDialog(
                                      message:
                                          'Are you sure you want to logout?',
                                      type: DialogType.info,
                                      secondBtnText: 'Logout',
                                      onConfirm: () {
                                        ref
                                            .read(userProvider.notifier)
                                            .logout(context: context,ref: ref);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }),
                            ),
                          ];
                        })
                //register
              ],
            ))
          // Nav items
        ],
      ),
    );
  }
}
