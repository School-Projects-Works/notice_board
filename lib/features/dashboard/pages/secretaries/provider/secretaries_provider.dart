import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/auth/services/user_services.dart';

import 'package:notice_board/features/dashboard/pages/secretaries/services/secretaries_services.dart';

import '../../../../auth/data/user_model.dart';

final secretariesStream = StreamProvider<List<UserModel>>((ref) async* {
  var data = SecretariesServices.streamSecretaries();
  await for (var event in data) {
    ref.read(secretariesProvider.notifier).setList(event);
    yield event;
  }
});

class SecretariesFilter {
  List<UserModel> list;
  List<UserModel> filterList;
  SecretariesFilter({
    required this.list,
    required this.filterList,
  });

  SecretariesFilter copyWith({
    List<UserModel>? list,
    List<UserModel>? filterList,
  }) {
    return SecretariesFilter(
      list: list ?? this.list,
      filterList: filterList ?? this.filterList,
    );
  }
}

final secretariesProvider =
    StateNotifierProvider<SecretariesProvider, SecretariesFilter>(
        (ref) => SecretariesProvider());

class SecretariesProvider extends StateNotifier<SecretariesFilter> {
  SecretariesProvider() : super(SecretariesFilter(list: [], filterList: []));

  void setList(List<UserModel> list) {
    state = state.copyWith(list: list, filterList: list);
  }

  void filter(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filterList: state.list);
    } else {
      state = state.copyWith(
          filterList: state.list
              .where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()))
              .toList());
    }
  }

  void block(UserModel secretary) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Blocking secretary');
    var data = await UserServices.updateUser(id:secretary.id, data:{'status':'banned'});
    if (data) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Secretary blocked successfully');
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to block secretary');
    }
  }

  void unblock(UserModel secretary) async{
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Unblocking secretary');
    var data = await UserServices.updateUser(id:secretary.id, data:{'status':'active'});
    if (data) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Secretary unblocked successfully');
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to unblock secretary');
    }
  }
}
