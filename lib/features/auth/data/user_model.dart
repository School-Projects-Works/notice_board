import 'dart:convert';
import 'package:flutter/foundation.dart';

class UserModel {
  String id;
  String name;
  String email;
  String role;
  String? password;
  List<String> affiliations;
  String? image;
  String status;
  String phone;
  int? createdAt;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.password,
    this.affiliations = const [],
    this.image,
    required this.phone,
    this.status='active',
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? password,
    List<String>? affiliations,
    String? image,
    String? phone,
    String? status,
    int? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
      affiliations: affiliations ?? this.affiliations,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'role': role});

    result.addAll({'affiliations': affiliations});
    if (image != null) {
      result.addAll({'image': image});
    } else {
      result.addAll({'image': null});
    }
    result.addAll({'phone': phone});
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    } else {
      result.addAll({'createdAt': DateTime.now().millisecondsSinceEpoch});
    }
    result.addAll({'status': status});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      affiliations: List<String>.from(map['affiliations']),
      image: map['image'],
      phone: map['phone'] ?? '',
      status: map['status'] ?? 'active',
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, password: $password, affiliations: $affiliations, image: $image, phone: $phone, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role &&
        other.password == password &&
        listEquals(other.affiliations, affiliations) &&
        other.image == image &&
        other.status == status &&
        other.phone == phone &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        role.hashCode ^
        password.hashCode ^
        affiliations.hashCode ^
        image.hashCode ^
        phone.hashCode ^
        status.hashCode ^
        createdAt.hashCode;
  }
}
