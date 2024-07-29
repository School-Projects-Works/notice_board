import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../notice/data/notice_model.dart';
import '../../notice/services/notice_services.dart';
import '../data/notice_list_model.dart';

final isUserSaerching = StateProvider<bool>((ref) => false);
final isUserFiltering = StateProvider<bool>((ref) => false);

final noticeListStream =
    StreamProvider.autoDispose<List<NoticeModel>>((ref) async* {
  var data = NoticeServices.streamNotice();
  await for (var item in data) {
    ref.read(noticeListProvider.notifier).setNoticeList(item);
    yield item;
  }
});

final noticeListProvider =
    StateNotifierProvider<NoticeList, NoticeListModel>((ref) {
  return NoticeList(ref:ref);
});

class NoticeList extends StateNotifier<NoticeListModel> {
  NoticeList({required this.ref}) : super(NoticeListModel(noticeList: [], filteredList: []));
  final StateNotifierProviderRef<NoticeList, NoticeListModel> ref;

  void setNoticeList(List<NoticeModel> list) {
    var aff = ref.watch(selectedAffiliation);
    var filteredList = list.where((element) {
      if (aff == 'All') {
        return true;
      } else {
        return element.affliation.contains(aff);
      }
    }).toList();
    state = state.copyWith(noticeList: list, filteredList: filteredList);
  }

}


final selectedAffiliation = StateProvider<String>((ref) => 'All');