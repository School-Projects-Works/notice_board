import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/features/affiliations/data/affiliation_model.dart';
import 'package:notice_board/features/affiliations/services/affiliation_services.dart';
import 'package:notice_board/features/notice/data/notice_model.dart';
import 'package:notice_board/utils/styles.dart';
import '../../notice/services/notice_services.dart';
import '../components/nav_bar.dart';

class ContainerPage extends ConsumerWidget {
  const ContainerPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var style = Styles(context);
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: NavBar()),
      body: FutureBuilder<bool>(
          future: saveDummyData(),
          builder: (context, snapshot) {
            return Container(
              color: Colors.white54,
              child: Center(
                child: child,
              ),
            );
          }),
    );
  }

  Future<bool> saveDummyData() async {
    //? save dummy affiliations
    try {
      // var data = AffiliationModel.dummyAffiliation();
      // for (var item in data) {
      //   await AffiliationServices.addAffiliation(item);
      // }
      // var data = NoticeModel.dummyNotice();
      // for (var item in data) {
      //   await NoticeServices.addNotice(item);
      // }
      return true;
    } catch (e) {
      return false;
    }
  }
}
