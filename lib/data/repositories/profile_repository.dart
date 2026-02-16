import '../models/hero_section_model.dart';
import '../models/skill_model.dart';
import '../services/firebase_service.dart';

class ProfileRepository {
  final FirebaseService _firebaseService;

  ProfileRepository(this._firebaseService);

  final String _collection = 'ProfileDetails';
  final String _documentId = 'MyDetail';

  Future<HeroSectionModel?> getHeroSection() async {
    final doc = await _firebaseService.getDocument(_collection, _documentId);
    if (doc.exists) {
      final data = doc.data()?['heroSection'] as Map<String, dynamic>?;
      if (data != null) {
        return HeroSectionModel.fromMap(data);
      }
    }
    return null;
  }

  Future<void> updateHeroSection(HeroSectionModel heroSection) async {
    await _firebaseService.updateDocument(_collection, _documentId, {
      'heroSection': heroSection.toMap(),
    });
  }

  Future<List<SkillModel>> getSkills() async {
    final doc = await _firebaseService.getDocument(_collection, _documentId);
    if (doc.exists) {
      final data = doc.data()?['skillsSection'] as List<dynamic>?;
      if (data != null) {
        return data
            .map((e) => SkillModel.fromMap(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  Future<void> updateSkills(List<SkillModel> skills) async {
    await _firebaseService.updateDocument(_collection, _documentId, {
      'skillsSection': skills.map((e) => e.toMap()).toList(),
    });
  }
}
