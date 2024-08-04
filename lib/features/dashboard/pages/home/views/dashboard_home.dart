import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/features/dashboard/pages/affiliations/provider/dash_affi_provider.dart';
import 'package:notice_board/features/dashboard/pages/request/provider/request_provider.dart';
import 'package:notice_board/features/dashboard/pages/secretaries/provider/secretaries_provider.dart';
import 'package:notice_board/features/dashboard/pages/students/provider/students_provider.dart';
import 'package:notice_board/features/notice/provider/notice_provider.dart';
import 'package:notice_board/router/router.dart';
import 'package:notice_board/router/router_items.dart';
import 'package:notice_board/utils/styles.dart';

import '../../../../../utils/colors.dart';
import '../../../../auth/provider/user_provider.dart';
import '../../../views/components/dasboard_item.dart';

class DashboardHomePage extends ConsumerStatefulWidget {
  const DashboardHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashboardHomePageState();
}

class _DashboardHomePageState extends ConsumerState<DashboardHomePage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var user = ref.watch(userProvider);
    var secretariesList = ref.watch(secretariesProvider);
    var noticesList = ref.watch(noticeListProvider);
    var secretaryNotices = noticesList.noticeRawList.where(
        (element) =>element.posterId==user.id ).toList();
    var affilationList = ref.watch(dashAffiliationProvider);
    var studentsList = ref.watch(studentsProvider);
    var requests = ref.watch(requestFilterProvider);
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const SizedBox(height: 20),
              Text(
                'Dashboard'.toUpperCase(),
                style: style.title(color: primaryColor),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (user.role == 'admin')
                    DashBoardItem(
                      icon: Icons.people,
                      title: 'Secretaries'.toUpperCase(),
                      itemCount: secretariesList.list.length,
                      color: Colors.blue,
                      onTap: () {
                        MyRouter(context: context,ref: ref).navigateToRoute(RouterItem.secretariesRoute);
                      },
                    ),
                    DashBoardItem(
                      icon: Icons.people_alt_outlined,
                      title: 'Affiliations'.toUpperCase(),
                      itemCount: affilationList.list.length,
                      color: Colors.green,
                      onTap: () {
                        MyRouter(context: context,ref: ref).navigateToRoute(RouterItem.departmentsRoute);
                      },
                    ),
                  DashBoardItem(
                    icon: Icons.hotel,
                    title: 'Notice'.toUpperCase(),
                    itemCount: user.role == 'admin'
                        ? noticesList.noticeRawList.length
                        : secretaryNotices.length,
                    color: Colors.orange,
                    onTap: () {
                      MyRouter(context: context,ref: ref).navigateToRoute(RouterItem.noticeRoute);
                    },
                  ),
                  DashBoardItem(
                    icon: Icons.room,
                    title: 'Students'.toUpperCase(),
                    itemCount: studentsList.list.length,
                    color: Colors.pink,
                    onTap: () {
                      MyRouter(context: context,ref: ref).navigateToRoute(RouterItem.studentsRoute);
                    },
                  ),
                  DashBoardItem(
                    icon: Icons.request_page,
                    title: 'Requests'.toUpperCase(),
                    itemCount: requests.list.length,
                    color: Colors.purple,
                    onTap: () {
                      MyRouter(context: context,ref: ref).navigateToRoute(RouterItem.requestRoute);
                    },
                  ),
                ],
              ),
            ])));
  }
}
