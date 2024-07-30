import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notice_board/features/auth/data/login_model.dart';
import 'package:notice_board/features/auth/data/user_model.dart';

class UserServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection =
      _firestore.collection('users');

  static Future<(bool, String)> createUser(UserModel user) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password!);
      if (userCredential.user != null) {
        //send email verification
        await userCredential.user!.sendEmailVerification();
        //save user to firestore
        user.id = userCredential.user!.uid;
        await _userCollection.doc(userCredential.user!.uid).set(user.toMap());
        //sign out user
        await _auth.signOut();
        return (true, 'User created successfully, please verify your email');
      } else {
        return (false, 'User not created');
      }
    } on FirebaseAuthException catch (e) {
      return (false, e.message.toString());
    } catch (e) {
      return (false, e.toString());
    }
  }

  static Future<(User?, UserModel?,String)> loginUser(LoginModel user) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      if (userCredential.user != null) {
       var user = await _userCollection.doc(userCredential.user!.uid).get();
       if(user.exists){
         return (userCredential.user, UserModel.fromMap(user.data()as Map<String, dynamic>),'Login successful');
        }else{
          return (null, null,'User not found');
        }
         } else {
        return (null, null,'User not found');
      }
    } on FirebaseAuthException catch (e) {
      return (null,null, e.message.toString());
    } catch (e) {
      return (null, null,e.toString());
    }
  }

  static Future<bool>resendEmailVerification(User? user) async{
    try {
      await user!.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<UserModel?>getUserData(String s)async {
    try {
      var user = await _userCollection.doc(s).get();
      return UserModel.fromMap(user.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }
}
