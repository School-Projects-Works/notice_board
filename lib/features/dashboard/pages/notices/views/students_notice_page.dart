
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/views/custom_input.dart';
import '../../../../../utils/styles.dart';
import '../../../../auth/provider/user_provider.dart';
import '../../../../home/views/components/notice_card.dart';
import '../../../../notice/data/notice_model.dart';
import '../../../../notice/provider/notice_provider.dart';
import 'student_notice_Card.dart';

class StudentsNoticePage extends ConsumerStatefulWidget {
  const StudentsNoticePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentsNoticePageState();
}

class _StudentsNoticePageState extends ConsumerState<StudentsNoticePage> {

  @override
  Widget build(BuildContext context) {
   var notices = ref.watch(noticeListProvider).filteredRawList.toList();
    var user = ref.watch(userProvider);
    var userAffi = user.affiliations.toList();
    List<NoticeModel> list = [];
    for (var element in notices) {
      if (element.affliation.contains('All') ||
          userAffi.any((aff) => element.affliation.contains(aff))) {
        list.add(element);
      }
    }
    notices = list.toList();
    notices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildStudentHeader(),
            const SizedBox(
              height: 20,
            ),
            if (notices.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 150),
                child: Center(
                  child: Text('No Notice Found'),
                ),
              )
            else
              Wrap(
                spacing: 10,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                runSpacing: 10,
                children: [
                  for (int i = 0;
                      i < (notices.length > 12 ? 12 : notices.length);
                      i++)
                    StudentsNoticeCard(
                      notice: notices[i],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
    
  }
  Widget _buildStudentHeader() {
    var style = Styles(context);
    if (style.largerThanMobile) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'My Notice',
            style: style.title(fontSize: 30),
          ),
          const Spacer(),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: style.isDesktop ? 500 : style.width * .3,
            child: CustomTextFields(
              hintText: 'Search Notice',
              suffixIcon: const Icon(Icons.search),
              onChanged: (query) {
                ref.read(noticeListProvider.notifier).search(query);
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      );
    } else {
      if (ref.watch(isStudentSaerching)) {
        return SizedBox(
          width: double.infinity,
          child: CustomTextFields(
            hintText: 'Search Notice',
            prefixIcon: Icons.search,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () {
                ref.read(isStudentSaerching.notifier).state = false;
              },
            ),
            onChanged: (notice) {
              ref.read(noticeListProvider.notifier).search(notice);
            },
          ),
        );
      } else {
        return Row(
          children: [
            Text(
              'Recent Notice',
              style: style.title(fontSize: 20),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ref.read(isStudentSaerching.notifier).state = true;
              },
            ),
          ],
        );
      }
    }
  }

}
final isStudentSaerching = StateProvider<bool>((ref) => false);
