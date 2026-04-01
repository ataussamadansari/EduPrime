class LessonModel {
  final int id;
  final String title;
  final String? description;
  final String lessonType;
  final String? videoUrl;
  final int durationMinutes;
  final int sortOrder;
  final bool isPreview;
  final bool isLocked;
  final bool isAccessible;
  final double? progressPercentage;

  const LessonModel({
    required this.id,
    required this.title,
    this.description,
    required this.lessonType,
    this.videoUrl,
    required this.durationMinutes,
    required this.sortOrder,
    required this.isPreview,
    required this.isLocked,
    required this.isAccessible,
    this.progressPercentage,
  });

  bool get isCompleted => (progressPercentage ?? 0) >= 100;

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'],
        lessonType: json['lesson_type'] ?? 'video',
        videoUrl: json['video_url'],
        durationMinutes: json['duration_minutes'] ?? 0,
        sortOrder: json['sort_order'] ?? 0,
        isPreview: json['is_preview'] ?? false,
        isLocked: json['is_locked'] ?? false,
        isAccessible: json['is_accessible'] ?? false,
        progressPercentage: json['progress_percentage'] != null
            ? double.tryParse(json['progress_percentage'].toString())
            : null,
      );
}

class CurriculumSection {
  final int id;
  final String title;
  final String? description;
  final int sortOrder;
  final List<LessonModel> lessons;

  const CurriculumSection({
    required this.id,
    required this.title,
    this.description,
    required this.sortOrder,
    required this.lessons,
  });

  factory CurriculumSection.fromJson(Map<String, dynamic> json) =>
      CurriculumSection(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'],
        sortOrder: json['sort_order'] ?? 0,
        lessons: (json['lessons'] as List? ?? [])
            .map((e) => LessonModel.fromJson(e))
            .toList(),
      );
}

class LessonProgressResult {
  final int lessonId;
  final int courseId;
  final double courseProgressPercentage;
  final int? lastAccessedLessonId;

  const LessonProgressResult({
    required this.lessonId,
    required this.courseId,
    required this.courseProgressPercentage,
    this.lastAccessedLessonId,
  });

  factory LessonProgressResult.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>;
    return LessonProgressResult(
      lessonId: d['lesson_id'],
      courseId: d['course_id'],
      courseProgressPercentage:
          (d['progress_percentage'] ?? 0).toDouble(),
      lastAccessedLessonId: d['last_accessed_lesson_id'],
    );
  }
}

class EnrollmentResult {
  final int enrollmentId;
  final int courseId;
  final String status;
  final String paymentStatus;

  const EnrollmentResult({
    required this.enrollmentId,
    required this.courseId,
    required this.status,
    required this.paymentStatus,
  });

  factory EnrollmentResult.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>;
    return EnrollmentResult(
      enrollmentId: d['enrollment_id'],
      courseId: d['course_id'],
      status: d['status'] ?? '',
      paymentStatus: d['payment_status'] ?? '',
    );
  }
}
