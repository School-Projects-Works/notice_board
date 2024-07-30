import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';

import 'package:notice_board/features/notice/services/notice_services.dart';

import '../../../constants/constant_data.dart';

class NoticeModel {
  String id;
  String title;
  String description;
  String posterId;
  String posterName;
  String contact;
  String? email;
  List<String> affliation;
  List<String> images;
  String status;
  int createdAt;
  NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterId,
    required this.posterName,
    required this.contact,
    this.email,
    this.affliation = const [],
    this.images = const [],
     this.status='unpublished',
    required this.createdAt,
  });

  NoticeModel copyWith({
    String? id,
    String? title,
    String? description,
    String? posterId,
    String? posterName,
    String? contact,
    String? email,
    List<String>? affliation,
    List<String>? images,
    String? status,
    int? createdAt,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterId: posterId ?? this.posterId,
      posterName: posterName ?? this.posterName,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      affliation: affliation ?? this.affliation,
      images: images ?? this.images,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'description': description});
    result.addAll({'posterId': posterId});
    result.addAll({'posterName': posterName});
    result.addAll({'contact': contact});
    if(email != null){
      result.addAll({'email': email});
    }
    result.addAll({'affliation': affliation});
    result.addAll({'images': images});
    result.addAll({'status': status});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      posterId: map['posterId'] ?? '',
      posterName: map['posterName'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'],
      affliation: List<String>.from(map['affliation']),
      images: List<String>.from(map['images']),
      status: map['status'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoticeModel.fromJson(String source) =>
      NoticeModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoticeModel(id: $id, title: $title, description: $description, posterId: $posterId, posterName: $posterName, contact: $contact, email: $email, affliation: $affliation, images: $images, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NoticeModel &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.posterId == posterId &&
      other.posterName == posterName &&
      other.contact == contact &&
      other.email == email &&
      listEquals(other.affliation, affliation) &&
      listEquals(other.images, images) &&
      other.status == status &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      posterId.hashCode ^
      posterName.hashCode ^
      contact.hashCode ^
      email.hashCode ^
      affliation.hashCode ^
      images.hashCode ^
      status.hashCode ^
      createdAt.hashCode;
  }

  static List<NoticeModel> dummyNotice() {
    var faker = Faker();
    var notice = <NoticeModel>[];
    var aff = [...departmentList];
    for (var i = 0; i < notices.length; i++) {
      //getrandom sub list of department
      var sublist = faker.randomGenerator.element(aff);
      notice.add(NoticeModel(
        id: NoticeServices.getNoticeId(),
        title: notices[i]['title'],
        description: notices[i]['content'],
        posterId: faker.guid.guid(),
        posterName: faker.person.name(),
        contact: faker.phoneNumber.us(),
        affliation: faker.randomGenerator.boolean() ? ['All'] : [sublist],
        images: notices[i]['images'] ?? [],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ));
    }
    return notice;
  }
}
