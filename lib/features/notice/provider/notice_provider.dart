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
  return NoticeList(ref: ref);
});

class NoticeList extends StateNotifier<NoticeListModel> {
  NoticeList({required this.ref})
      : super(NoticeListModel(noticeList: [], filteredList: [], noticeRawList: [], filteredRawList: []));
  final StateNotifierProviderRef<NoticeList, NoticeListModel> ref;

  void setNoticeList(List<NoticeModel> list) {
    var publishedList = list.where((element) => element.status == 'published').toList();
    state = state.copyWith(noticeList: publishedList, filteredList: publishedList, noticeRawList: list, filteredRawList: list);
  }

  void search(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredList: state.noticeList);
      return;
    }
    var list = state.noticeList.where((element) {
      return element.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredList: list);
  }

  void filter(String aff) {
    if (aff.trim().toLowerCase() == 'all') {
      state = state.copyWith(filteredList: state.noticeList);
      return;
    }
    var filteredList = state.noticeList.where((element) {
      return element.affliation.contains(aff);
    }).toList();
    state = state.copyWith(filteredList: filteredList);
    ref.read(selectedAffiliation.notifier).state = aff;
  }
}

final selectedAffiliation = StateProvider<String>((ref) => 'All');
