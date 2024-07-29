import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_drop_down.dart';
import 'package:notice_board/core/views/custom_input.dart';
import 'package:notice_board/features/affiliations/provider/affiliation_provider.dart';
import '../../../../utils/styles.dart';
import '../../../notice/provider/notice_provider.dart';
import 'notice_card.dart';

class NoticeListPage extends ConsumerStatefulWidget {
  const NoticeListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoticeListPageState();
}

class _NoticeListPageState extends ConsumerState<NoticeListPage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var noticeStream = ref.watch(noticeListStream);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: noticeStream.when(data: (data) {
          var noticeList = ref.watch(noticeListProvider).filteredList;
          return Column(
            children: [
             // _buildHeader(),
              const SizedBox(
                height: 20,
              ),
              if(noticeList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 150),
                  child: Center(
                    child: Text('No Notice Found'),
                  ),
                )
              else
               Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.start,
                children: noticeList
                      .map((notice) => NoticeCard(notice: notice)).toList(),
              )
            ],
          );
        },
            error: (error, stack) {
              return const Center(
                child: Text('Error loading data'),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        ));
  }

}
