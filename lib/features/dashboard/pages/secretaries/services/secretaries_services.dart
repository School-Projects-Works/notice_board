import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/features/auth/data/user_model.dart';

class SecretariesServices{
  static final CollectionReference secretariesCollection = FirebaseFirestore.instance.collection('users');


  static  Stream<List<UserModel>> streamSecretaries() {
    return secretariesCollection.where('role',whereIn: ['secretary','Secretary']).snapshots().map((event) => event.docs.map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>)).toList());
  }
}