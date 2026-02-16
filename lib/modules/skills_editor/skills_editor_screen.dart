import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/skill_model.dart';
import 'skills_editor_controller.dart';
import 'widgets/skill_card.dart';
import 'widgets/skill_dialog.dart';
import 'widgets/skills_empty_state.dart';

class SkillsEditorScreen extends GetView<SkillsEditorController> {
  const SkillsEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(
      () => PopScope(
        canPop: !controller.hasChanges,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await _showExitConfirmation(context);
          if (shouldPop) {
            Get.back();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Manage Skills'),
            actions: [
              IconButton(
                onPressed: controller.hasChanges ? controller.saveSkills : null,
                icon: const Icon(Icons.save_rounded),
                tooltip: 'Save to Firestore',
              ),
            ],
          ),
          body: Stack(
            children: [
              Obx(() {
                if (controller.skills.isEmpty && !controller.isLoading.value) {
                  return SkillsEmptyState(onSeed: controller.seedSkills);
                }

                return RefreshIndicator(
                  onRefresh: controller.loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: SkillsEditorController.categories.map((category) {
                      final categorySkills = controller.skills
                          .where((s) => s.category == category)
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCategoryHeader(
                            context,
                            category,
                            theme,
                            isDark,
                          ),
                          const SizedBox(height: 12),
                          if (categorySkills.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 24,
                                left: 16,
                              ),
                              child: Text(
                                'No skills in this category',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            )
                          else
                            ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categorySkills.length,
                              onReorder: (oldIndex, newIndex) => controller
                                  .reorderSkills(category, oldIndex, newIndex),
                              itemBuilder: (context, index) {
                                final skill = categorySkills[index];
                                final actualIndex = controller.skills.indexOf(
                                  skill,
                                );

                                return Padding(
                                  key: ValueKey(
                                    '${category}_${skill.name}_$index',
                                  ),
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: SkillCard(
                                    skill: skill,
                                    onEdit: () => _showSkillDialog(
                                      context,
                                      index: actualIndex,
                                      skill: skill,
                                    ),
                                    onDelete: () =>
                                        _confirmDelete(context, actualIndex),
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
              // Loading overlay to preserve scroll state
              Obx(() {
                if (controller.isLoading.value) {
                  return Container(
                    color: Colors.black.withValues(alpha: 0.1),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showSkillDialog(context),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    String category,
    ThemeData theme,
    bool isDark,
  ) {
    final color = AppColors.categoryColor(category);
    final label = SkillsEditorController.categoryLabels[category] ?? category;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                .withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    final skill = controller.skills[index];
    final removedSkill = skill;

    controller.deleteSkill(index);

    Get.snackbar(
      'Skill Deleted',
      '"${removedSkill.name}" removed',
      mainButton: TextButton(
        onPressed: () {
          controller.skills.insert(index, removedSkill);
          if (Get.isSnackbarOpen) Get.back();
        },
        child: const Text(
          'UNDO',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }

  void _showSkillDialog(BuildContext context, {int? index, SkillModel? skill}) {
    Get.dialog(
      SkillDialog(
        index: index,
        skill: skill,
        onSave: (newSkill) {
          if (index == null) {
            controller.addSkill(newSkill);
          } else {
            controller.updateSkill(index, newSkill);
          }
        },
      ),
    );
  }
}
