import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/skill_model.dart';
import '../skills_editor_controller.dart';

class SkillDialog extends StatefulWidget {
  final int? index;
  final SkillModel? skill;
  final Function(SkillModel) onSave;

  const SkillDialog({super.key, this.index, this.skill, required this.onSave});

  @override
  State<SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<SkillDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController tagCtrl;
  late final TextEditingController expertiseCtrl;
  late final TextEditingController descriptionCtrl;
  late final TextEditingController docUrlCtrl;
  late final TextEditingController searchSuffixCtrl;
  late String category;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.skill?.name);
    tagCtrl = TextEditingController(text: widget.skill?.tag);
    expertiseCtrl = TextEditingController(text: widget.skill?.expertise);
    descriptionCtrl = TextEditingController(text: widget.skill?.description);
    docUrlCtrl = TextEditingController(text: widget.skill?.docUrl);
    searchSuffixCtrl = TextEditingController(text: widget.skill?.searchSuffix);
    category = widget.skill?.category ?? 'core';
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    tagCtrl.dispose();
    expertiseCtrl.dispose();
    descriptionCtrl.dispose();
    docUrlCtrl.dispose();
    searchSuffixCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.index == null ? 'Add Skill' : 'Edit Skill'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.code_rounded),
                hintText: 'e.g. Swift',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagCtrl,
              decoration: const InputDecoration(
                labelText: 'Tag',
                prefixIcon: Icon(Icons.label_outline_rounded),
                hintText: 'e.g. Language',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: expertiseCtrl,
              decoration: const InputDecoration(
                labelText: 'Expertise',
                prefixIcon: Icon(Icons.star_outline_rounded),
                hintText: 'e.g. Expert, Advanced, Proficient',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: category,
              items: SkillsEditorController.categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppColors.categoryColor(c),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            SkillsEditorController.categoryLabels[c] ??
                                c.toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => category = v!);
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: docUrlCtrl,
              decoration: const InputDecoration(
                labelText: 'Documentation URL (optional)',
                prefixIcon: Icon(Icons.link_rounded),
                hintText: 'https://...',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: searchSuffixCtrl,
              decoration: const InputDecoration(
                labelText: 'Search Suffix (optional)',
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'e.g. programming language',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (nameCtrl.text.trim().isEmpty) {
              Get.snackbar(
                'Error',
                'Name is required',
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            final newSkill = SkillModel(
              name: nameCtrl.text.trim(),
              tag: tagCtrl.text.trim(),
              expertise: expertiseCtrl.text.trim(),
              category: category,
              description: descriptionCtrl.text.trim(),
              docUrl: docUrlCtrl.text.trim().isNotEmpty
                  ? docUrlCtrl.text.trim()
                  : null,
              searchSuffix: searchSuffixCtrl.text.trim().isNotEmpty
                  ? searchSuffixCtrl.text.trim()
                  : null,
            );

            widget.onSave(newSkill);
            Get.back();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
