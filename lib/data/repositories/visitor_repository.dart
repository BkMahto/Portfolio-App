import '../models/visitor_model.dart';
import '../services/firebase_service.dart';

class VisitorRepository {
  final FirebaseService _firebaseService;

  VisitorRepository(this._firebaseService);

  Stream<List<VisitorModel>> getVisitorsStream() {
    return _firebaseService.getVisitorsStream().map((event) {
      final snapshot = event.snapshot;
      if (!snapshot.exists || snapshot.value == null) return [];

      final data = snapshot.value as Map<dynamic, dynamic>;
      final visitors = <VisitorModel>[];

      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          visitors.add(VisitorModel.fromMap(key.toString(), value));
        }
      });

      // Sort by last visit descending
      visitors.sort((a, b) => b.info.lastVisit.compareTo(a.info.lastVisit));

      return visitors;
    });
  }
}
