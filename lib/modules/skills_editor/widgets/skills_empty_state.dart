import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class SkillsEmptyState extends StatelessWidget {
  final VoidCallback onSeed;

  const SkillsEmptyState({super.key, required this.onSeed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.code_off_rounded,
            size: 64,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No skills added yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first skill',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onSeed,
            icon: const Icon(Icons.cloud_upload_rounded),
            label: const Text('Seed Default Skills'),
          ),
        ],
      ),
    );
  }
}
