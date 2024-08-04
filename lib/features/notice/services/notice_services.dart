import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:notice_board/features/notice/data/notice_model.dart';

class NoticeServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _noticeCollection =
      _firestore.collection('notices');
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final Reference _storageRef = _storage.ref().child('notices');

  static String getNoticeId() {
    return _noticeCollection.doc().id;
  }

  static Future<bool> addNotice(NoticeModel notice) async {
    try {
      await _noticeCollection.doc(notice.id).set(notice.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateNotice({required String id, required Map<String,dynamic> data}) async {
    try {
      await _noticeCollection.doc(id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteNotice(String id) async {
    try {
      await _noticeCollection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<NoticeModel>> streamNotice() {
    return _noticeCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => NoticeModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<List<NoticeModel>> getAllNotice() async {
    var data = await _noticeCollection.get();
    return data.docs
        .map((doc) => NoticeModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  static Future<List<String>> uploadNoticeImages(String id, List<Uint8List> data) async {
    try {
      var urls = <String>[];
      for (var i = 0; i < data.length; i++) {
        var ref = _storageRef.child('$id/$i.jpeg');
        await ref.putData(data[i], SettableMetadata(contentType: 'image/jpeg'));
        var url = await ref.getDownloadURL();
        urls.add(url);
      }
      return urls;
    } catch (e) {
      return [];
    }
  }
}
