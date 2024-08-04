import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/notice/data/notice_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:notice_board/features/dashboard/pages/request/services/request_services.dart';
import '../../../../notice/services/notice_services.dart';
import '../data/request_model.dart';

final requestStreamProvider =
    StreamProvider.autoDispose<List<RequestModel>>((ref) async* {
  var data = RequestServices.streamRequest();
  await for (var item in data) {
    ref.read(requestFilterProvider.notifier).setList(item);
    yield item;
  }
});

class RequestFilter {
  List<RequestModel> list;
  List<RequestModel> filter;
  RequestFilter({
    required this.list,
    required this.filter,
  });

  RequestFilter copyWith({
    List<RequestModel>? list,
    List<RequestModel>? filter,
  }) {
    return RequestFilter(
      list: list ?? this.list,
      filter: filter ?? this.filter,
    );
  }
}

final requestFilterProvider =
    StateNotifierProvider<RequestFilterProvider, RequestFilter>(
        (ref) => RequestFilterProvider());

class RequestFilterProvider extends StateNotifier<RequestFilter> {
  RequestFilterProvider() : super(RequestFilter(list: [], filter: []));

  void setList(List<RequestModel> list) {
    state = state.copyWith(list: list, filter: list);
  }

  void filter(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.list);
    } else {
      var data = state.list.where((element) {
        return element.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: data);
    }
  }

  void deleteNotice(String id) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Deleting Request');
    var data = await RequestServices.deleteRequest(id);
    if (data) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Request Deleted', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Error Deleting Request', type: DialogType.error);
    }
  }

  void rejectRequest({required String id}) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Rejecting Request');
    var data = await RequestServices.updateRequest(
        id: id, data: {'status': 'rejected'});
    if (data) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Request Rejected', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Error Rejecting Request', type: DialogType.error);
    }
  }

  void publishRequest({required String id}) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Publishing Request');
    //update status to published and move to notice board
    //after that delete the request
    var data = await RequestServices.updateRequest(
        id: id, data: {'status': 'published'});
    //get the request
    var request =
        state.list.toList().where((element) => element.id == id).firstOrNull;
    if (request != null) {
      var notice = NoticeModel.fromMap(request.toMap());
      var noticeId = NoticeServices.getNoticeId();
      notice = notice.copyWith(id: noticeId,status: 'published');
      var noticeData = await NoticeServices.addNotice(notice);
      if (noticeData) {
        var deleteRequest = await RequestServices.deleteRequest(id);
        if (deleteRequest) {
          CustomDialogs.dismiss();
          CustomDialogs.toast(
              message: 'Request Published', type: DialogType.success);
        } else {
          CustomDialogs.dismiss();
          CustomDialogs.toast(
              message: 'Error Publishing Request', type: DialogType.error);
        }
      } else {
        CustomDialogs.dismiss();
        CustomDialogs.toast(
            message: 'Error Publishing Request', type: DialogType.error);
      }
    }else{
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Error Publishing Request', type: DialogType.error);
    }

  }
}
