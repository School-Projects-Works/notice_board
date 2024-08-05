import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/functions/sms_gpt_model.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/dashboard/pages/notices/views/notices_page.dart';
import 'package:notice_board/features/dashboard/pages/students/provider/students_provider.dart';
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
    if (string.isEmpty || string == 'null') return;
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
    //put ai here to check offensive content
    var content = '${state.title}.${state.description}';
    var results = await SmsGptModel.contentContainProfain(content);
    if (results > 2) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Your content contains offensive words. Please remove them');
      return;
    }
    if (image.isNotEmpty) {
      //check if image is offensive
      for (var image in image) {
        var result = await SmsGptModel.imageIsProfain(image);
        if (result > 2) {
          CustomDialogs.dismiss();
          CustomDialogs.showDialog(
              message:
                  'Your image contains offensive content. Please remove it',
              type: DialogType.error);
          return;
        }
      }

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
      //get all the users and send them a notification
      var users = ref.watch(studentsProvider).list;
      //check if student has the same affliation
      if (state.affliation.contains('All')) {
        for (var element in users) {
         await SmsGptModel.sendMessage(element.phone,
              'New notice is available on the notice board. Check it out now');
        }
      }else{
        for (var element in users) {
          var studentAff = element.affiliations.toList();
          var noticeAff = state.affliation.toList();
          var common = studentAff.where((element) => noticeAff.contains(element)).toList();
          if(common.isNotEmpty){
            await SmsGptModel.sendMessage(element.phone,
                'New notice is available on the notice board. Check it out now');
          }
        }
      }
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

final editNoticeProvider =
    StateNotifierProvider<EditNotice, NoticeModel>((ref) => EditNotice());

class EditNotice extends StateNotifier<NoticeModel> {
  EditNotice()
      : super(NoticeModel(
          id: '',
          title: '',
          description: '',
          contact: '',
          posterId: '',
          posterName: '',
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));

  void setNotice(NoticeModel notice) {
    state = notice;
  }

  void setContent(String s) {
    state = state.copyWith(description: s);
  }

  void setTitle(String s) {
    state = state.copyWith(title: s);
  }

  void addAffiliation(String string) {
    var data = state.affliation.toList();
    data.add(string);
    state = state.copyWith(affliation: data);
  }

  void removeAff(String aff) {
    var data = state.affliation.toList();
    data.remove(aff);
    state = state.copyWith(affliation: data);
  }

  void removeNotice() {
    state = NoticeModel(
      id: '',
      title: '',
      description: '',
      contact: '',
      posterId: '',
      posterName: '',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  void updateNotice(WidgetRef ref) async {
    CustomDialogs.loading(message: 'Updating Notice....');
    var image = ref.watch(noticeImageProvider);
    if (image.isNotEmpty) {
      var urls = await NoticeServices.uploadNoticeImages(state.id, image);
      state = state.copyWith(images: urls);
    }
    var result =
        await NoticeServices.updateNotice(id: state.id, data: state.toMap());
    if (result) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Notice Updated');
      state = NoticeModel(
        id: '',
        title: '',
        description: '',
        contact: '',
        posterId: '',
        posterName: '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to update notice');
    }
  }
}
