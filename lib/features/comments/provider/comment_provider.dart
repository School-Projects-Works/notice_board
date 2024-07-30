import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notice_board/core/views/custom_dialog.dart';
import 'package:notice_board/features/comments/data/comments_model.dart';
import 'package:notice_board/features/comments/services/comment_services.dart';

import '../../auth/provider/user_provider.dart';

final commentStream = StreamProvider.autoDispose
    .family<List<CommentsModel>, String>((ref, id) async* {
  var data = CommentServices.streamComment(id);
  await for (var item in data) {
    yield item;
  }
});


final newCommentProvider = StateNotifierProvider<NewComment,CommentsModel>((ref) {
  return NewComment();
});

class NewComment extends StateNotifier<CommentsModel> {
  NewComment() : super(CommentsModel(id: '', noticeId: '', comment: '', createdAt: DateTime.now().millisecondsSinceEpoch, userId: '', userName: ''));

  void addComment({required String noticeId, required String comment, required WidgetRef ref})async {
    CustomDialogs.loading(message: 'Adding Comment...',);
    var user = ref.read(userProvider);
    state = state.copyWith(
      id: CommentServices.getCommentId(),
      noticeId: noticeId,
      comment: comment,
      userId: user.id,
      userImage: user.image,
      userName: user.name,
      createdAt: DateTime.now().millisecondsSinceEpoch

    );
    var result = await CommentServices.addComment(state);
    if(result){
      CustomDialogs.toast(message: 'Comment Added Successfully',type: DialogType.success);
    }else{
      CustomDialogs.toast(message: 'Failed to add Comment',type: DialogType.error);
    }
  }
  
}