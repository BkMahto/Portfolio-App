import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import 'hero_editor_controller.dart';
import 'widgets/hero_form_field.dart';

class HeroEditorScreen extends GetView<HeroEditorController> {
  const HeroEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: const Text('Edit Hero Section'),
            actions: [
              IconButton(
                onPressed: controller.hasChanges ? controller.updateData : null,
                icon: const Icon(Icons.save_rounded),
                tooltip: 'Update Hero Section',
              ),
            ],
          ),
          body: Stack(
            children: [
              Form(
                key: controller.formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    HeroFormField(
                      controller: controller.appRatingCtrl,
                      label: 'App Rating',
                      hint: 'e.g. 4.8+',
                      icon: Icons.star_outline_rounded,
                    ),
                    HeroFormField(
                      controller: controller.appsPublishedCtrl,
                      label: 'Apps Published',
                      hint: 'e.g. 10+',
                      icon: Icons.apps_rounded,
                    ),
                    HeroFormField(
                      controller: controller.experienceCtrl,
                      label: 'Years of Experience',
                      hint: 'e.g. 3+',
                      icon: Icons.work_outline_rounded,
                    ),
                    HeroFormField(
                      controller: controller.projectsWorkedCtrl,
                      label: 'Projects Worked',
                      hint: 'e.g. 25+',
                      icon: Icons.folder_outlined,
                    ),
                    const SizedBox(height: 32),

                    // Gradient update button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: controller.hasChanges
                                ? AppColors.primaryGradient
                                : [Colors.grey.shade600, Colors.grey.shade400],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (controller.hasChanges
                                          ? AppColors.primary
                                          : Colors.grey)
                                      .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: controller.hasChanges
                              ? controller.updateData
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Update Hero Section',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: controller.hasChanges
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
}
