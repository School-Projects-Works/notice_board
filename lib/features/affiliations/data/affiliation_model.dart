import 'dart:convert';

import '../../../constants/constant_data.dart';
import '../services/affiliation_services.dart';

class AffiliationModel {
  String id;
  String name;
  String secretaryId;
  String secretaryName;
  String contact;
  int createdAt;
  AffiliationModel({
    required this.id,
    required this.name,
    required this.secretaryId,
    required this.secretaryName,
    required this.contact,
    required this.createdAt,
  });

  AffiliationModel copyWith({
    String? id,
    String? name,
    String? secretaryId,
    String? secretaryName,
    String? contact,
    int? createdAt,
  }) {
    return AffiliationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      secretaryId: secretaryId ?? this.secretaryId,
      secretaryName: secretaryName ?? this.secretaryName,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'secretaryId': secretaryId});
    result.addAll({'secretaryName': secretaryName});
    result.addAll({'contact': contact});
    result.addAll({'createdAt': createdAt});

    return result;
  }

  factory AffiliationModel.fromMap(Map<String, dynamic> map) {
    return AffiliationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      secretaryId: map['secretaryId'] ?? '',
      secretaryName: map['secretaryName'] ?? '',
      contact: map['contact'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AffiliationModel.fromJson(String source) =>
      AffiliationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AffiliationModel(id: $id, name: $name, secretaryId: $secretaryId, secretaryName: $secretaryName, contact: $contact, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AffiliationModel &&
        other.id == id &&
        other.name == name &&
        other.secretaryId == secretaryId &&
        other.secretaryName == secretaryName &&
        other.contact == contact &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        secretaryId.hashCode ^
        secretaryName.hashCode ^
        contact.hashCode ^
        createdAt.hashCode;
  }

  static List<AffiliationModel> dummyAffiliation() {
    List<AffiliationModel> affiliations = [];
    for (var dep in departmentList) {
      var id = AffiliationServices.getAffiliationId();
      var affiliation = AffiliationModel(
          id: id,
          name: dep,
          secretaryId: '',
          secretaryName: '',
          contact: '',
          createdAt: DateTime.now().millisecondsSinceEpoch);
      affiliations.add(affiliation);
    }
    return affiliations;
  }
}
