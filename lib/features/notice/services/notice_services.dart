import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  static Future<bool> updateNotice(NoticeModel notice) async {
    try {
      await _noticeCollection.doc(notice.id).update(notice.toMap());
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
}
