import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/auth/data/user_model.dart';

import 'package:notice_board/features/affiliations/data/affiliation_model.dart';
import 'package:notice_board/features/affiliations/services/affiliation_services.dart';
import 'package:notice_board/features/auth/services/user_services.dart';

final dashAffiStreamProvider =
    StreamProvider<List<AffiliationModel>>((ref) async* {
  var data = AffiliationServices.streamAffiliations();
  await for (var item in data) {
    ref.read(dashAffiliationProvider.notifier).setList(item);
    yield item;
  }
});

class AffiliationFilter {
  List<AffiliationModel> list;
  List<AffiliationModel> filter;
  AffiliationFilter({required this.list, required this.filter});

  AffiliationFilter copyWith({
    List<AffiliationModel>? list,
    List<AffiliationModel>? filter,
  }) {
    return AffiliationFilter(
      list: list ?? this.list,
      filter: filter ?? this.filter,
    );
  }
}

final dashAffiliationProvider =
    StateNotifierProvider<AffiProvider, AffiliationFilter>((ref) {
  return AffiProvider();
});

class AffiProvider extends StateNotifier<AffiliationFilter> {
  AffiProvider() : super(AffiliationFilter(list: [], filter: []));

  void setList(List<AffiliationModel> list) {
    state = state.copyWith(list: list, filter: list);
  }

  void filterList(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.list);
    } else {
      var data = state.list.where((element) {
        return element.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: data);
    }
  }

  void delete(AffiliationModel affiliation, WidgetRef ref) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Deleting affiliation');
    var data = await AffiliationServices.deleteAffiliation(affiliation.id);
    if (data) {
      var update = await UserServices.updateUser(
          id: affiliation.secreataryId, data: {'role': 'student'});
      CustomDialogs.dismiss();
      ref.read(dashAffiStreamProvider);
      CustomDialogs.toast(
          message: 'Affiliation deleted', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to delete affiliation', type: DialogType.error);
    }
  }
}


final editAffiliationProvider =
    StateNotifierProvider<EditAffiliation, AffiliationModel>((ref) {
  return EditAffiliation();
});

class EditAffiliation extends StateNotifier<AffiliationModel> {
  EditAffiliation()
      : super(AffiliationModel(
            name: '',
            secreataryName: '',
            contact: '',
            id: '',
            secreataryId: '',
            createdAt: DateTime.now().millisecondsSinceEpoch));

void setAffiliation(AffiliationModel affiliation) {
    state = affiliation;
  }
  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setScretary(UserModel user) {
    state = state.copyWith(secreataryName: user.name, secreataryId: user.id);
  }

  void setContact(String contact) {
    state = state.copyWith(contact: contact);
  }

  void reset() {
    state = AffiliationModel(
        name: '',
        secreataryName: '',
        contact: '',
        id: '',
        secreataryId: '',
        createdAt: DateTime.now().millisecondsSinceEpoch);
  }

  void save(WidgetRef ref) async {
    CustomDialogs.loading(message: 'Saving affiliation');
    var data = await AffiliationServices.updateAffiliation(state.id, state.toMap());
    
    if (data) {
      //make user a secreatary
      var update = await UserServices.updateUser(id: state.secreataryId, data: {'role':'secreatary'});
      CustomDialogs.dismiss();
      ref.read(dashAffiStreamProvider);
      CustomDialogs.toast(
          message: 'Affiliation updated', type: DialogType.success);
      reset();
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to update affiliation', type: DialogType.error);
    }
  }
}


final newAffProvider =
    StateNotifierProvider<NewAffiliation, AffiliationModel>((ref) {
  return NewAffiliation();
});

class NewAffiliation extends StateNotifier<AffiliationModel> {
  NewAffiliation()
      : super(AffiliationModel(
            name: '',
            secreataryName: '',
            contact: '',
            id: '',
            secreataryId: '',
            createdAt: DateTime.now().millisecondsSinceEpoch));

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setScretary(UserModel user) {
    state = state.copyWith(secreataryName: user.name, secreataryId: user.id);
  }

  void setContact(String contact) {
    state = state.copyWith(contact: contact);
  }

  void reset() {
    state = AffiliationModel(
        name: '',
        secreataryName: '',
        contact: '',
        id: '',
        secreataryId: '',
        createdAt: DateTime.now().millisecondsSinceEpoch);
  }

  void save(WidgetRef ref) async {
    CustomDialogs.loading(message: 'Saving affiliation');
    state = state.copyWith(id: AffiliationServices.getAffiliationId(),createdAt: DateTime.now().millisecondsSinceEpoch);
    var data = await AffiliationServices.addAffiliation(state);
    if (data) {
      var update = await UserServices.updateUser(
          id: state.secreataryId, data: {'role': 'secreatary'});
      CustomDialogs.dismiss();
      //ref.read(dashAffiStreamProvider);
      CustomDialogs.toast(
          message: 'Affiliation added', type: DialogType.success);
      reset();
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to add affiliation', type: DialogType.error);
    }
  }
}
