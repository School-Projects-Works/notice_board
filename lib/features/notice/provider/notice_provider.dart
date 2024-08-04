import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
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
      : super(NoticeListModel(
            noticeList: [],
            filteredList: [],
            noticeRawList: [],
            filteredRawList: []));
  final StateNotifierProviderRef<NoticeList, NoticeListModel> ref;

  void setNoticeList(List<NoticeModel> list) {
    var publishedList =
        list.where((element) => element.status == 'published').toList();
    state = state.copyWith(
        noticeList: publishedList,
        filteredList: publishedList,
        noticeRawList: list,
        filteredRawList: list);
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

  void searchInRaw(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredRawList: state.noticeRawList);
      return;
    }
    var list = state.noticeRawList.where((element) {
      return element.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    state = state.copyWith(filteredRawList: list);
  }

  void updateNotice({required String id, required String status})async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Updating Notice...');
    var responds = await NoticeServices.updateNotice(id: id, data: {'status': status});
    if (responds) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Notice Updated Successfully', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Update Notice', type: DialogType.error);
    }

  }

  void deleteNotice(String id)async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Deleting Notice...');
    var responds = await NoticeServices.deleteNotice(id);
    if (responds) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Notice Deleted Successfully', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Delete Notice', type: DialogType.error);
    }
  }
}

final selectedAffiliation = StateProvider<String>((ref) => 'All');
