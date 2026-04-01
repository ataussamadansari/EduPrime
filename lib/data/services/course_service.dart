import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

class CourseService {
  final Dio _dio = ApiClient.instance.dio;

  /// GET /courses?search=&category_id=&featured=&is_free=&page=
  Future<Map<String, dynamic>> getCourses({
    String? search,
    int? categoryId,
    bool? featured,
    bool? isFree,
    int page = 1,
  }) async {
    final res = await _dio.get('/courses', queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      if (categoryId != null) 'category_id': categoryId,
      if (featured != null) 'featured': featured,
      if (isFree != null) 'is_free': isFree,
      'page': page,
    });
    return res.data as Map<String, dynamic>;
  }

  /// GET /courses/{id}
  Future<Map<String, dynamic>> getCourseDetail(int id) async {
    final res = await _dio.get('/courses/$id');
    return res.data as Map<String, dynamic>;
  }

  /// GET /courses/{id}/curriculum
  Future<Map<String, dynamic>> getCourseCurriculum(int courseId) async {
    final res = await _dio.get('/courses/$courseId/curriculum');
    return res.data as Map<String, dynamic>;
  }

  /// POST /courses/{id}/enroll
  Future<Map<String, dynamic>> enrollCourse(int courseId) async {
    final res = await _dio.post('/courses/$courseId/enroll');
    return res.data as Map<String, dynamic>;
  }

  /// GET /my-courses
  Future<Map<String, dynamic>> getMyCourses() async {
    final res = await _dio.get('/my-courses');
    return res.data as Map<String, dynamic>;
  }

  /// GET /lessons/{id}
  Future<Map<String, dynamic>> getLesson(int lessonId) async {
    final res = await _dio.get('/lessons/$lessonId');
    return res.data as Map<String, dynamic>;
  }

  /// POST /lessons/{id}/progress
  Future<Map<String, dynamic>> updateLessonProgress(
    int lessonId, {
    required double progressPercentage,
    required int watchedSeconds,
    required bool isCompleted,
  }) async {
    final res = await _dio.post('/lessons/$lessonId/progress', data: {
      'progress_percentage': progressPercentage,
      'watched_seconds': watchedSeconds,
      'is_completed': isCompleted,
    });
    return res.data as Map<String, dynamic>;
  }

  /// GET /courses/{id}/reviews
  Future<Map<String, dynamic>> getCourseReviews(int courseId) async {
    final res = await _dio.get('/courses/$courseId/reviews');
    return res.data as Map<String, dynamic>;
  }

  /// POST /courses/{id}/reviews
  Future<Map<String, dynamic>> submitReview(
    int courseId, {
    required int rating,
    required String title,
    required String review,
  }) async {
    final res = await _dio.post('/courses/$courseId/reviews', data: {
      'rating': rating,
      'title': title,
      'review': review,
    });
    return res.data as Map<String, dynamic>;
  }

  /// GET /featured-courses
  Future<Map<String, dynamic>> getFeaturedCourses() async {
    final res = await _dio.get('/featured-courses');
    return res.data as Map<String, dynamic>;
  }

  /// GET /continue-learning
  Future<Map<String, dynamic>> getContinueLearning() async {
    final res = await _dio.get('/continue-learning');
    return res.data as Map<String, dynamic>;
  }

  /// GET /course-categories
  Future<Map<String, dynamic>> getCourseCategories() async {
    final res = await _dio.get('/course-categories');
    return res.data as Map<String, dynamic>;
  }
}
