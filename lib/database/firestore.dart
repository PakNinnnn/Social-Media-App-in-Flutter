/*

This database stores the post users had posted in a collection called 'posts'

Each post contain:
- a message
- username
- timestamp

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;

  //Get collection from Firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("posts");

  //Add data to database
  Future<void> addPost(String message) {
    return posts.add({
      'email': user!.email,
      'message': message,
      'timestamp': Timestamp.now() 
    });
  }

  //Read data from database
  Stream<QuerySnapshot> getPost(){
    return posts.orderBy("timestamp", descending: true).snapshots();
  }
}

