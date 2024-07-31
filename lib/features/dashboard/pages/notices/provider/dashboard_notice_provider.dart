import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/notice/data/notice_model.dart';

final newNoticeProvider = StateNotifierProvider<NewNoticeProvider, NoticeModel>(
    (ref) => NewNoticeProvider());

class NewNoticeProvider extends StateNotifier<NoticeModel> {
  NewNoticeProvider()
      : super(NoticeModel(
          id: '',
          title: '',
          description: '',
          contact: '',
          posterId: '',
          posterName: '',
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));

  void setTitle(String s) {
    state = state.copyWith(title: s);
  }

  void addAffiliation(String string) {
    var affi = state.affliation.toList();
    affi.add(string);
    state = state.copyWith(affliation: affi);
  }

  void setContent(String s) {
    state = state.copyWith(description: s);
  }

  void removeAff(String aff) {
    var affi = state.affliation.toList();
    affi.remove(aff);
    state = state.copyWith(affliation: affi);
  }

  void publish(WidgetRef ref) async {
    CustomDialogs.loading(message: 'Publishing Message...');
    
  }
}
