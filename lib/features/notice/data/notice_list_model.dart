import 'notice_model.dart';

class NoticeListModel {
  List<NoticeModel> noticeRawList;
  List<NoticeModel> noticeList;
  List<NoticeModel> filteredList;
  List<NoticeModel> filteredRawList;
  NoticeListModel({
    required this.noticeList,
    required this.filteredList,
    required this.noticeRawList,
    required this.filteredRawList,
  });

  NoticeListModel copyWith({
    List<NoticeModel>? noticeList,
    List<NoticeModel>? filteredList,
    List<NoticeModel>? noticeRawList,
    List<NoticeModel>? filteredRawList,
  }) {
    return NoticeListModel(
      noticeList: noticeList ?? this.noticeList,
      filteredList: filteredList ?? this.filteredList,
      noticeRawList: noticeRawList ?? this.noticeRawList,
      filteredRawList: filteredRawList ?? this.filteredRawList,
    );
  }
}
