import 'notice_model.dart';

class NoticeListModel {
  List<NoticeModel> noticeList;
  List<NoticeModel> filteredList;
  NoticeListModel({
    required this.noticeList,
    required this.filteredList,
  });

  NoticeListModel copyWith({
    List<NoticeModel>? noticeList,
    List<NoticeModel>? filteredList,
  }) {
    return NoticeListModel(
      noticeList: noticeList ?? this.noticeList,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}
