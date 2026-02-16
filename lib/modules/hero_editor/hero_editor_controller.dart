import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/hero_section_model.dart';
import '../../data/repositories/profile_repository.dart';

class HeroEditorController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final appRatingCtrl = TextEditingController();
  final appsPublishedCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final projectsWorkedCtrl = TextEditingController();
  final isLoading = false.obs;
  final _fieldsVersion = 0.obs;

  final ProfileRepository _repository = Get.find<ProfileRepository>();
  HeroSectionModel? _currentData;

  bool get hasChanges {
    _fieldsVersion.value; // Access to trigger Obx
    if (_currentData == null) return false;
    return appRatingCtrl.text.trim() != _currentData!.appRating ||
        appsPublishedCtrl.text.trim() != _currentData!.appsPublished ||
        experienceCtrl.text.trim() != _currentData!.experience ||
        projectsWorkedCtrl.text.trim() != _currentData!.projectsWorked;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
    appRatingCtrl.addListener(_onFieldChanged);
    appsPublishedCtrl.addListener(_onFieldChanged);
    experienceCtrl.addListener(_onFieldChanged);
    projectsWorkedCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => _fieldsVersion.value++;

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final data = await _repository.getHeroSection();
      if (data != null) {
        _currentData = data;
        appRatingCtrl.text = data.appRating;
        appsPublishedCtrl.text = data.appsPublished;
        experienceCtrl.text = data.experience;
        projectsWorkedCtrl.text = data.projectsWorked;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateData() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final newData = HeroSectionModel(
        appRating: appRatingCtrl.text.trim(),
        appsPublished: appsPublishedCtrl.text.trim(),
        experience: experienceCtrl.text.trim(),
        projectsWorked: projectsWorkedCtrl.text.trim(),
      );

      await _repository.updateHeroSection(newData);
      await loadData();

      Get.snackbar(
        'Success',
        'Hero Section updated!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Update failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    appRatingCtrl.dispose();
    appsPublishedCtrl.dispose();
    experienceCtrl.dispose();
    projectsWorkedCtrl.dispose();
    super.onClose();
  }
}
