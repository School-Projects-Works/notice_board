import 'dart:convert';

import '../../../constants/constant_data.dart';
import '../services/affiliation_services.dart';

class AffiliationModel {
  String id;
  String name;
  String secreataryId;
  String secreataryName;
  String contact;
  int createdAt;
  AffiliationModel({
    required this.id,
    required this.name,
    required this.secreataryId,
    required this.secreataryName,
    required this.contact,
    required this.createdAt,
  });

  AffiliationModel copyWith({
    String? id,
    String? name,
    String? secreataryId,
    String? secreataryName,
    String? contact,
    int? createdAt,
  }) {
    return AffiliationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      secreataryId: secreataryId ?? this.secreataryId,
      secreataryName: secreataryName ?? this.secreataryName,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'secreataryId': secreataryId});
    result.addAll({'secreataryName': secreataryName});
    result.addAll({'contact': contact});
    result.addAll({'createdAt': createdAt});
  
    return result;
  }

  factory AffiliationModel.fromMap(Map<String, dynamic> map) {
    return AffiliationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      secreataryId: map['secreataryId'] ?? '',
      secreataryName: map['secreataryName'] ?? '',
      contact: map['contact'] ?? '',
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AffiliationModel.fromJson(String source) => AffiliationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AffiliationModel(id: $id, name: $name, secreataryId: $secreataryId, secreataryName: $secreataryName, contact: $contact, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AffiliationModel &&
      other.id == id &&
      other.name == name &&
      other.secreataryId == secreataryId &&
      other.secreataryName == secreataryName &&
      other.contact == contact &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      secreataryId.hashCode ^
      secreataryName.hashCode ^
      contact.hashCode ^
      createdAt.hashCode;
  }

  static List<AffiliationModel> dummyAffiliation() {
    List<AffiliationModel> affiliations = [];
    for(var dep in departmentList){
      var id = AffiliationServices.getAffiliationId();
      var affiliation = AffiliationModel(
        id: id,
        name: dep,
        secreataryId: '',
        secreataryName: '',
        contact: '',
        createdAt: DateTime.now().millisecondsSinceEpoch
      );
      affiliations.add(affiliation);
    }
    return affiliations;
  }
}
