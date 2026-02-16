import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/visitor_model.dart';

class VisitorTile extends StatelessWidget {
  final VisitorModel visitor;
  final VoidCallback onTap;

  const VisitorTile({super.key, required this.visitor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final info = visitor.info;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[200]!),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getOSColor(info.browser).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getOSIcon(info.browser),
            color: _getOSColor(info.browser),
            size: 24,
          ),
        ),
        title: Text(
          '${info.city}, ${info.region}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              info.country,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  info.readableTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${visitor.events.length} events • ${info.ip}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  IconData _getOSIcon(String browser) {
    final b = browser.toLowerCase();
    if (b.contains('bot') ||
        b.contains('crawler') ||
        b.contains('headlesschrome')) {
      return Icons.smart_toy_outlined;
    }
    if (b.contains('iphone')) {
      return Icons.phone_iphone;
    }
    if (b.contains('ipad')) {
      return Icons.tablet_mac;
    }
    if (b.contains('android')) {
      return Icons.android;
    }
    if (b.contains('macintosh')) {
      return Icons.desktop_mac;
    }
    if (b.contains('windows')) {
      return Icons.laptop_windows;
    }
    if (b.contains('linux')) {
      return Icons.terminal;
    }
    return Icons.public_rounded;
  }

  Color _getOSColor(String browser) {
    final b = browser.toLowerCase();
    if (b.contains('bot') ||
        b.contains('crawler') ||
        b.contains('headlesschrome')) {
      return Colors.orange[700]!;
    }
    if (b.contains('iphone')) {
      return Colors.blueGrey[600]!;
    }
    if (b.contains('ipad')) {
      return Colors.blueGrey[700]!;
    }
    if (b.contains('android')) {
      return Colors.green[600]!;
    }
    if (b.contains('macintosh')) {
      return Colors.grey[800]!;
    }
    if (b.contains('windows')) {
      return Colors.blue[600]!;
    }
    return Colors.grey[600]!;
  }
}
