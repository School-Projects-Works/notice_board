import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/features/dashboard/pages/request/data/request_model.dart';
import 'package:notice_board/features/dashboard/pages/request/services/request_services.dart';
import 'package:notice_board/features/dashboard/pages/request/views/request_page.dart';

import '../../../../../core/functions/sms_gpt_model.dart';
import '../../../../../core/views/custom_dialog.dart';
import '../../../../auth/provider/user_provider.dart';

final newRequestProvider = StateNotifierProvider<NewRequest,RequestModel>((ref)=>NewRequest());

class NewRequest extends StateNotifier<RequestModel>{
  NewRequest() : super(RequestModel.defualt());


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

  void submit(WidgetRef ref) async {
    CustomDialogs.loading(message: 'submiting Request...');
    var id = RequestServices.getRequestID();
    var user = ref.watch(userProvider);
    var image = ref.watch(requestImageProvider);
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

      var urls = await RequestServices.uploadRequestImages(id, image);
      state = state.copyWith(images: urls);
    }
    state = state.copyWith(
        id: id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        posterId: user.id,
        posterName: user.name,
        contact: user.phone,
        email: user.email,
        status: 'pending');
    var result = await RequestServices.addRequest(state);
    if (result) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Request Submitted');
      ref.read(isNewRequest.notifier).state = false;
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to submit request');
    }
  }
}

final requestImageProvider =
    StateNotifierProvider<RequestImages, List<Uint8List>>(
        (ref) => RequestImages());

class RequestImages extends StateNotifier<List<Uint8List>> {
  RequestImages() : super([]);

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

