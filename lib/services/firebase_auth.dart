import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreAuthServices{
  Future<User?> getCurrentUserEmail() async{
    return await FirebaseAuth.instance.currentUser;
  }

  void logout() {
      FirebaseAuth.instance.signOut();
    }

  
}