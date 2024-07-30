import 'package:riverpod/riverpod.dart';

import 'package:notice_board/features/affiliations/data/affiliation_model.dart';
import 'package:notice_board/features/affiliations/services/affiliation_services.dart';

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


final dashAffiliationProvider = StateNotifierProvider<AffiProvider, AffiliationFilter>((ref) {
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
}