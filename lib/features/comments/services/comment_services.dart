import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/features/comments/data/comments_model.dart';

class CommentServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _commentCollection =
      _firestore.collection('comments');

  static String getCommentId() {
    return _commentCollection.doc().id;
  }

  static Future<bool> addComment(CommentsModel comment) async {
    try {
      await _commentCollection.doc(comment.id).set(comment.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateComment(CommentsModel comment) async {
    try {
      await _commentCollection.doc(comment.id).update(comment.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteComment(String id) async {
    try {
      await _commentCollection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<CommentsModel>> streamComment(String noticeId)  {
    var snap =
        _commentCollection.where('noticeId', isEqualTo: noticeId).snapshots();
    return snap.map((event) => event.docs
        .map((e) => CommentsModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }
}
