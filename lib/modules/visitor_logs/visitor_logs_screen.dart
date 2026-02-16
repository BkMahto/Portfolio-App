import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import 'visitor_logs_controller.dart';
import 'widgets/stat_card.dart';
import 'widgets/visitor_tile.dart';
import '../../data/models/visitor_model.dart';

class VisitorLogsScreen extends GetView<VisitorLogsController> {
  const VisitorLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitor Logs & Analytics'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.visitors.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async => controller.onInit(),
          child: CustomScrollView(
            slivers: [
              // Analytics Dashboard
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Insights',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Total Sessions',
                              value: controller.totalSessions.value.toString(),
                              icon: Icons.analytics_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              title: 'Unique Visitors',
                              value: controller.uniqueVisitors.value.toString(),
                              icon: Icons.people_alt_rounded,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      StatCard(
                        title: 'Total Interaction Events',
                        value: controller.totalEvents.value.toString(),
                        icon: Icons.touch_app_rounded,
                        color: AppColors.tertiary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Recent Activity',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Session List
              if (controller.visitors.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('No visitor data found')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final visitor = controller.visitors[index];
                      return VisitorTile(
                        visitor: visitor,
                        onTap: () => _showVisitorDetails(context, visitor),
                      );
                    }, childCount: controller.visitors.length),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      }),
    );
  }

  void _showVisitorDetails(BuildContext context, VisitorModel visitor) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${visitor.info.city}, ${visitor.info.region}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    visitor.info.country,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            // Info Grid
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildInfoRow('IP Address', visitor.info.ip),
                  _buildInfoRow('Browser', visitor.info.browser),
                  _buildInfoRow('Screen Size', visitor.info.screenSize),
                  _buildInfoRow('Region', visitor.info.region),
                  _buildInfoRow('Provider', visitor.info.org),

                  const SizedBox(height: 24),
                  Text(
                    'Event Timeline',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (visitor.events.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('No events recorded')),
                    )
                  else
                    ...visitor.events.map(
                      (event) => _buildEventItem(theme, event),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildEventItem(ThemeData theme, VisitorEvent event) {
    IconData icon = Icons.event_note_rounded;
    Color color = Colors.grey;
    final name = event.eventName.toLowerCase();

    if (name.contains('view')) {
      icon = Icons.visibility_rounded;
      color = AppColors.primary;
    } else if (name.contains('docs')) {
      icon = Icons.description_rounded;
      color = AppColors.secondary;
    } else if (name.contains('search')) {
      icon = Icons.search_rounded;
      color = Colors.orange;
    } else if (name.contains('modal')) {
      icon = Icons.open_in_new_rounded;
      color = AppColors.tertiary;
    } else if (name.contains('click')) {
      icon = Icons.touch_app_rounded;
      color = AppColors.secondary;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatEventName(event),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  event.readableTime,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatEventName(VisitorEvent event) {
    String name = event.eventName.replaceAll('_', ' ').capitalizeFirst!;
    if (event.skillName != null) {
      name += ': ${event.skillName}';
    } else if (event.method != null) {
      name += ': ${event.method}';
    }
    return name;
  }
}
