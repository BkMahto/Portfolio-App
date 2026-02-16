import 'package:get/get.dart';
import '../theme/theme_controller.dart';
import '../../data/services/firebase_service.dart';
import '../../data/repositories/profile_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController(), permanent: true);
    Get.put(FirebaseService(), permanent: true);
    Get.put(ProfileRepository(Get.find<FirebaseService>()), permanent: true);
  }
}
