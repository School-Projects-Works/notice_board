import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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

  static Future<List<String>>uploadRequestImages(id, List<Uint8List> image) async{
    List<String> urls = [];
    for (var img in image) {
      var ref = FirebaseStorage.instance.ref().child('request/$id/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(img, SettableMetadata(contentType: 'image/jpg'));
      var url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}