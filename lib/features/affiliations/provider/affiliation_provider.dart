import 'package:notice_board/features/affiliations/data/affiliation_model.dart';
import 'package:notice_board/features/affiliations/services/affiliation_services.dart';
import 'package:riverpod/riverpod.dart';

final affiliationFutureProvider =
    FutureProvider.autoDispose<List<AffiliationModel>>((ref) async {
  try {
    List<AffiliationModel> data = await AffiliationServices.getAffData();
    return data;
  } catch (e) {
    return [];
  }
});
