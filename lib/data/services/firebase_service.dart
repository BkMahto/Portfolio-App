import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Add more generic methods as needed (set, delete, collection stream, etc.)
}
