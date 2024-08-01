import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/features/affiliations/data/affiliation_model.dart';

class AffiliationServices{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

static String getAffiliationId() {
    return _firestore.collection('affiliations').doc().id;
  }
  static Future<bool> addAffiliation(AffiliationModel data) async {
   
    try {
      await _firestore.collection('affiliations').doc(data.id).set(data.toMap());
      return true;
    } catch (e) {
      return false;
    } 
  }

  static Future<bool> updateAffiliation(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('affiliations').doc(id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> deleteAffiliation(String id) async {
    try {
      await _firestore.collection('affiliations').doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<AffiliationModel>>getAffData()async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('affiliations').get();
      List<AffiliationModel> data = querySnapshot.docs.map((doc) => AffiliationModel.fromMap(doc.data() as Map<String,dynamic>)).toList();
      return data;
    } catch (e) {
      return [];
    }
  }

  static Stream<List<AffiliationModel>> streamAffiliations() {
    return _firestore.collection('affiliations').snapshots().map((event) => event.docs.map((e) => AffiliationModel.fromMap(e.data())).toList());
  }
}