import 'package:dio/dio.dart';
import '../services/course_service.dart';
import '../models/course_detail_model.dart';
import '../models/course_category_model.dart';
import '../models/courses_list_model.dart';
import '../models/dashboard_model.dart';
import '../models/lesson_model.dart';
import '../models/review_model.dart';

class CourseRepository {
  final CourseService _service = CourseService();

  Future<CoursesListModel> getCourses({
    String? search,
    int? categoryId,
    bool? featured,
    bool? isFree,
    int page = 1,
  }) async {
    try {
      final data = await _service.getCourses(
        search: search,
        categoryId: categoryId,
        featured: featured,
        isFree: isFree,
        page: page,
      );
      return CoursesListModel.fromJson(data);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<CourseDetailModel> getCourseDetail(int id) async {
    try {
      final data = await _service.getCourseDetail(id);
      return CourseDetailModel.fromJson(data);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<DashboardCourse>> getFeaturedCourses() async {
    try {
      final data = await _service.getFeaturedCourses();
      return (data['data'] as List)
          .map((e) => DashboardCourse.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<DashboardCourse>> getContinueLearning() async {
    try {
      final data = await _service.getContinueLearning();
      return (data['data'] as List)
          .map((e) => DashboardCourse.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<CourseCategoryModel>> getCourseCategories() async {
    try {
      final data = await _service.getCourseCategories();
      return (data['data'] as List)
          .map((e) => CourseCategoryModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<CurriculumSection>> getCourseCurriculum(int courseId) async {
    try {
      final data = await _service.getCourseCurriculum(courseId);
      return (data['data'] as List)
          .map((e) => CurriculumSection.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<EnrollmentResult> enrollCourse(int courseId) async {
    try {
      final data = await _service.enrollCourse(courseId);
      return EnrollmentResult.fromJson(data);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<DashboardCourse>> getMyCourses() async {
    try {
      final data = await _service.getMyCourses();
      return (data['data'] as List)
          .map((e) => DashboardCourse.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<LessonModel> getLesson(int lessonId) async {
    try {
      final data = await _service.getLesson(lessonId);
      return LessonModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<LessonProgressResult> updateLessonProgress(
    int lessonId, {
    required double progressPercentage,
    required int watchedSeconds,
    required bool isCompleted,
  }) async {
    try {
      final data = await _service.updateLessonProgress(
        lessonId,
        progressPercentage: progressPercentage,
        watchedSeconds: watchedSeconds,
        isCompleted: isCompleted,
      );
      return LessonProgressResult.fromJson(data);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<List<ReviewModel>> getCourseReviews(int courseId) async {
    try {
      final data = await _service.getCourseReviews(courseId);
      return (data['data'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<ReviewModel> submitReview(
    int courseId, {
    required int rating,
    required String title,
    required String review,
  }) async {
    try {
      final data = await _service.submitReview(
        courseId,
        rating: rating,
        title: title,
        review: review,
      );
      return ReviewModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  String _parseError(DioException e) {
    if (e.error is String) return e.error as String;
    final msg = e.response?.data?['message'];
    return msg?.toString() ?? e.message ?? 'Something went wrong';
  }
}
