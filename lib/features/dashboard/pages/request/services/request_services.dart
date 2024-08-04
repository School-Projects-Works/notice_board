import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/features/dashboard/pages/request/data/request_model.dart';

class RequestServices{

  static final CollectionReference requestCollection = FirebaseFirestore.instance.collection('requests');


  static String getRequestID(){
    return requestCollection.doc().id;
  }

  static Future<bool> addRequest(RequestModel data) async {
    try {
      await requestCollection.doc(data.id).set(data.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateRequest({required String id, required Map<String,dynamic> data}) async {
    try {
      await requestCollection.doc(id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteRequest(String id) async {
    try {
      await requestCollection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<RequestModel>> streamRequest() {
    return requestCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => RequestModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }
}