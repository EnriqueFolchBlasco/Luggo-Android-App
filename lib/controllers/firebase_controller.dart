import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserToFirestore(String uid, String email, String username) async {
    final doc = _firestore.collection('users').doc(uid);

    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'uid': uid,
        'email': email,
        'username': username,
      });
    }
  }

  Future<String?> fetchUsername(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()?['username'];
    }
    return null;
  }
}
