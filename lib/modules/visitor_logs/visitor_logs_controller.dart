import 'package:get/get.dart';
import '../../data/models/visitor_model.dart';
import '../../data/repositories/visitor_repository.dart';

class VisitorLogsController extends GetxController {
  final VisitorRepository _repository = Get.find<VisitorRepository>();

  final visitors = <VisitorModel>[].obs;
  final isLoading = true.obs;

  // Analytics observables
  final totalSessions = 0.obs;
  final uniqueVisitors = 0.obs;
  final totalEvents = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _bindVisitors();
  }

  void _bindVisitors() {
    visitors.bindStream(_repository.getVisitorsStream());

    // Listen to changes to update analytics
    ever(visitors, (List<VisitorModel> data) {
      isLoading.value = false;
      _calculateAnalytics(data);
    });
  }

  void _calculateAnalytics(List<VisitorModel> data) {
    totalSessions.value = data.length;

    final ips = data.map((v) => v.info.ip).toSet();
    uniqueVisitors.value = ips.length;

    int eventsCount = 0;
    for (var visitor in data) {
      eventsCount += visitor.events.length;
    }
    totalEvents.value = eventsCount;
  }
}
