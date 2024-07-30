import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../auth/data/user_model.dart';

class StudentsServices {
  static final CollectionReference secretariesCollection =
      FirebaseFirestore.instance.collection('users');

  static Stream<List<UserModel>> streamStudents() {
    return secretariesCollection
        .where('role', whereIn: ['student', 'Student'])
        .snapshots()
        .map((event) => event.docs
            .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}
