import 'package:flutter/material.dart';
import '../network/tvShow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppState with ChangeNotifier {
  late FirestoreService _firestoreService;

  AppState() {
    _firestoreService = FirestoreService();
  }

  FirestoreService get firestoreService => _firestoreService;
}

class FirestoreService {
  Future<void> addDocument(Map<String, dynamic> data) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .doc('/users/$uid')
        .collection('watchlist')
        .add(data);
  }

  Future<void> deleteDocument(int id) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('/users/$uid/watchlist').get().then((snapshot) {
      snapshot.docs.forEach((document) {
        if (document.data()['id'] == id) {
          document.reference.delete();
        }
      });
    });
  }

  Future<bool> contains(TvShow tvShow) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('/users/$uid/watchlist')
        .where('id', isEqualTo: tvShow.id)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Stream<QuerySnapshot> getDocuments() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('/users/$uid/watchlist').snapshots();
  }
}