import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_routes.dart';
import '../../data/models/course_detail_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/review_model.dart';
import '../../data/repositories/course_repository.dart';

class CourseDetailController extends GetxController {
  final _repo = CourseRepository();

  final Rx<CourseDetailModel?> course = Rx(null);
  final RxList<CurriculumSection> curriculum = <CurriculumSection>[].obs;
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isEnrolling = false.obs;
  final RxBool isSubmittingReview = false.obs;
  final RxString error = ''.obs;
  final RxSet<int> expandedSections = <int>{0}.obs;

  final RxInt reviewRating = 5.obs;
  final TextEditingController reviewTitleCtrl = TextEditingController();
  final TextEditingController reviewBodyCtrl = TextEditingController();

  late int _courseId;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments;
    if (id is int) {
      _courseId = id;
      _loadAll(id);
    }
  }

  Future<void> _loadAll(int id) async {
    isLoading.value = true;
    error.value = '';
    try {
      final results = await Future.wait([
        _repo.getCourseDetail(id),
        _repo.getCourseCurriculum(id),
        _repo.getCourseReviews(id),
      ]);
      course.value = results[0] as CourseDetailModel;
      curriculum.value = results[1] as List<CurriculumSection>;
      reviews.value = results[2] as List<ReviewModel>;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() => _loadAll(_courseId);

  // ── Enroll ────────────────────────────────────────────────────────────────
  // Free  → POST /enroll directly
  // Paid  → Payment screen → user confirms → POST /enroll → refresh
  Future<void> enroll() async {
    final c = course.value;
    if (c == null) return;

    if (!c.isFree) {
      await Get.toNamed(AppRoutes.payment, arguments: _courseId);
      // Refresh after returning from payment
      try {
        course.value = await _repo.getCourseDetail(_courseId);
      } catch (_) {}
      return;
    }

    isEnrolling.value = true;
    try {
      await _repo.enrollCourse(_courseId);
      final updated = await _repo.getCourseDetail(_courseId);
      course.value = updated;
      Get.snackbar(
        'Enrolled!',
        'You are now enrolled in ${updated.title}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isEnrolling.value = false;
    }
  }

  // ── Continue Learning ─────────────────────────────────────────────────────
  // Opens first incomplete accessible lesson
  void continueLearning() {
    if (curriculum.isEmpty) return;

    LessonModel? target;
    for (final section in curriculum) {
      for (final lesson in section.lessons) {
        if (!lesson.isCompleted && lesson.isAccessible) {
          target = lesson;
          break;
        }
      }
      if (target != null) break;
    }
    // Fallback: first accessible lesson (all completed case)
    target ??= curriculum
        .expand((s) => s.lessons)
        .where((l) => l.isAccessible)
        .firstOrNull;

    if (target == null) {
      Get.snackbar('All Done!', 'You have completed all lessons.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _openLesson(target);
  }

  // ── Open specific lesson from curriculum tap ──────────────────────────────
  void openLesson(LessonModel lesson) {
    if (lesson.isLocked) {
      Get.snackbar('Locked', 'Enroll to access this lesson.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _openLesson(lesson);
  }

  void _openLesson(LessonModel lesson) {
    Get.toNamed(AppRoutes.lessonPlayer, arguments: {
      'lessonId': lesson.id,
      'courseId': _courseId,
    });
  }

  // ── Review ────────────────────────────────────────────────────────────────
  Future<void> submitReview() async {
    final title = reviewTitleCtrl.text.trim();
    final body = reviewBodyCtrl.text.trim();
    if (title.isEmpty || body.isEmpty) {
      Get.snackbar('Validation', 'Please fill title and review.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSubmittingReview.value = true;
    try {
      final newReview = await _repo.submitReview(
        _courseId,
        rating: reviewRating.value,
        title: title,
        review: body,
      );
      reviews.insert(0, newReview);
      reviewTitleCtrl.clear();
      reviewBodyCtrl.clear();
      reviewRating.value = 5;
      Get.back();
      Get.snackbar('Thanks!', 'Your review has been submitted.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmittingReview.value = false;
    }
  }

  void toggleSection(int index) {
    if (expandedSections.contains(index)) {
      expandedSections.remove(index);
    } else {
      expandedSections.add(index);
    }
  }

  @override
  void onClose() {
    reviewTitleCtrl.dispose();
    reviewBodyCtrl.dispose();
    super.onClose();
  }
}
