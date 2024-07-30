import 'dart:convert';
import 'package:faker/faker.dart';

class CommentsModel {
  String id;
  String comment;
  String userId;
  String userName;
  String? userImage;
  String noticeId;
  int createdAt;
  CommentsModel({
    required this.id,
    required this.comment,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.noticeId,
    required this.createdAt,
  });

  CommentsModel copyWith({
    String? id,
    String? comment,
    String? userId,
    String? userName,
    String? userImage,
    String? noticeId,
    int? createdAt,
  }) {
    return CommentsModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      noticeId: noticeId ?? this.noticeId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'comment': comment});
    result.addAll({'userId': userId});
    result.addAll({'userName': userName});
    if(userImage != null){
      result.addAll({'userImage': userImage});
    }
    result.addAll({'noticeId': noticeId});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      id: map['id'] ?? '',
      comment: map['comment'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userImage: map['userImage'],
      noticeId: map['noticeId'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentsModel.fromJson(String source) =>
      CommentsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommentsModel(id: $id, comment: $comment, userId: $userId, userName: $userName, userImage: $userImage, noticeId: $noticeId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CommentsModel &&
      other.id == id &&
      other.comment == comment &&
      other.userId == userId &&
      other.userName == userName &&
      other.userImage == userImage &&
      other.noticeId == noticeId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      comment.hashCode ^
      userId.hashCode ^
      userName.hashCode ^
      userImage.hashCode ^
      noticeId.hashCode ^
      createdAt.hashCode;
  }

  static List<CommentsModel> dummyComments(String noticeId) {
    List<CommentsModel> comments = [];
    var faker = Faker();
    var randomCount = faker.randomGenerator.integer(10, min: 2);
    for (var i = 0; i < randomCount; i++) {
      comments.add(CommentsModel(
        id: faker.guid.guid(),
        userName: faker.person.name(),
        userImage: faker.randomGenerator.boolean()? faker.image.image(): null,
        comment: faker.lorem
            .sentences(faker.randomGenerator.integer(5, min: i))
            .join(''),
        userId: faker.guid.guid(),
        noticeId: noticeId,
        createdAt: 0,
      ));
    }
    return comments;
  }
}
