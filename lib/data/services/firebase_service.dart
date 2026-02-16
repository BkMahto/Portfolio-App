import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collection,
    String documentId,
  ) {
    return _firestore.collection(collection).doc(documentId).get();
  }

  Future<void> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collection).doc(documentId).update(data);
  }

  Stream<DatabaseEvent> getVisitorsStream() {
    return _database.ref('visitors').onValue;
  }
}
