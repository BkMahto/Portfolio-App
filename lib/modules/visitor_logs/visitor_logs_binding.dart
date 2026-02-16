import 'package:get/get.dart';
import 'visitor_logs_controller.dart';

class VisitorLogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitorLogsController>(() => VisitorLogsController());
  }
}
