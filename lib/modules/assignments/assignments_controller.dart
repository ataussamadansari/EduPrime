import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../../data/models/assignment_api_model.dart';
import '../../data/repositories/assignment_repository.dart';

class AssignmentsController extends GetxController {
  final _repo = AssignmentRepository();

  final RxList<AssignmentApiModel> assignments = <AssignmentApiModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString filter = 'all'.obs; // all | pending | submitted | graded

  List<AssignmentApiModel> get filtered {
    switch (filter.value) {
      case 'pending':
        return assignments.where((a) => !a.isSubmitted).toList();
      case 'submitted':
        return assignments
            .where((a) => a.isSubmitted && !a.isGraded)
            .toList();
      case 'graded':
        return assignments.where((a) => a.isGraded).toList();
      default:
        return assignments;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    isLoading.value = true;
    error.value = '';
    try {
      assignments.value = await _repo.getAssignments();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String f) => filter.value = f;
}

// ── Per-assignment detail controller ─────────────────────────────────────────
class AssignmentDetailController extends GetxController {
  final _repo = AssignmentRepository();

  final Rx<AssignmentApiModel?> assignment = Rx(null);
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;

  final submissionTextCtrl = TextEditingController();
  final RxString pickedFilePath = ''.obs;
  final RxString pickedFileName = ''.obs;

  late int assignmentId;

  @override
  void onInit() {
    super.onInit();
    assignmentId = Get.arguments as int;
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    error.value = '';
    try {
      assignment.value = await _repo.getAssignment(assignmentId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() => _load();

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png'],
      );
      if (result != null && result.files.single.path != null) {
        pickedFilePath.value = result.files.single.path!;
        pickedFileName.value = result.files.single.name;
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not pick file. Please restart the app.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void clearFile() {
    pickedFilePath.value = '';
    pickedFileName.value = '';
  }

  Future<void> submit() async {
    final text = submissionTextCtrl.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Validation', 'Please enter your submission text.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSubmitting.value = true;
    try {
      final sub = await _repo.submitAssignment(assignmentId,
          submissionText: text,
          filePath: pickedFilePath.value.isNotEmpty
              ? pickedFilePath.value
              : null);
      // Update local assignment with new submission
      final a = assignment.value;
      if (a != null) {
        assignment.value = AssignmentApiModel(
          id: a.id,
          title: a.title,
          description: a.description,
          instructions: a.instructions,
          dueAt: a.dueAt,
          maxMarks: a.maxMarks,
          submissionType: a.submissionType,
          status: a.status,
          course: a.course,
          submission: sub,
        );
      }
      submissionTextCtrl.clear();
      Get.snackbar('Submitted!', 'Your assignment has been submitted.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    submissionTextCtrl.dispose();
    super.onClose();
  }
}
