import 'package:riverpod/riverpod.dart';

import '../../../../auth/data/user_model.dart';
import '../services/students_services.dart';

final studentsStreamProvider = StreamProvider<List<UserModel>>((ref)async* {
  var data = StudentsServices.streamStudents();
  await for (var item in data) {
    ref.read(studentsProvider.notifier).setList(item);
    yield item;
  }
  
});

class StudentsFilter {
  List<UserModel> list;
  List<UserModel> filter;
  StudentsFilter({required this.list, required this.filter});

  StudentsFilter copyWith({
    List<UserModel>? list,
    List<UserModel>? filter,
  }) {
    return StudentsFilter(
      list: list ?? this.list,
      filter: filter ?? this.filter,
    );
  }
}


final studentsProvider = StateNotifierProvider<StudentsProvider,StudentsFilter>((ref){
  return StudentsProvider();
});

class StudentsProvider extends StateNotifier<StudentsFilter> {
  StudentsProvider():super(StudentsFilter(list: [],filter: []));

  void setList(List<UserModel> list){
    state = state.copyWith(list: list,filter: list);
  }

  void filterList(String query){
    if(query.isEmpty){
      state = state.copyWith(filter: state.list);
    }else{
      var data = state.list.where((element) {
        return element.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: data);
    }
  }
}