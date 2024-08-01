import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/dashboard/pages/notices/views/notices_page.dart';
import 'package:notice_board/features/notice/data/notice_model.dart';
import 'package:notice_board/features/notice/services/notice_services.dart';

import '../../../../auth/provider/user_provider.dart';

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
    var id = NoticeServices.getNoticeId();
    var user = ref.watch(userProvider);
    var image = ref.watch(noticeImageProvider);
    if (image.isNotEmpty) {
      var urls = await NoticeServices.uploadNoticeImages(id, image);
      state = state.copyWith(images: urls);
    }
    state = state.copyWith(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        posterId: user.id,
        posterName: user.name,
        contact: user.phone,
        email: user.email,
        status: 'published');
    var result = await NoticeServices.addNotice(state);
    if (result) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Notice Published');
      ref.read(isNewNotice.notifier).state = false;
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to publish notice');
    }
  }
}

final noticeImageProvider =
    StateNotifierProvider<NoticeImages, List<Uint8List>>(
        (ref) => NoticeImages());

class NoticeImages extends StateNotifier<List<Uint8List>> {
  NoticeImages() : super([]);

  void addImage(List<Uint8List> data) {
    var images = state.toList();
    images = images..addAll(data);
    state = images;
  }

  void removeImage(Uint8List index) {
    var images = state.toList();
    images.remove(index);
    state = images;
  }
}
