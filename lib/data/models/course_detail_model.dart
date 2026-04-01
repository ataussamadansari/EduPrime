import 'dashboard_model.dart';

class CourseDetailModel {
  final int id;
  final String title;
  final String subtitle;
  final String? description;
  final String thumbnailUrl;
  final double price;
  final double? salePrice;
  final bool isFree;
  final bool isFeatured;
  final String level;
  final String language;
  final String durationText;
  final double averageRating;
  final int reviewsCount;
  final double? progressPercentage;
  final bool isEnrolled;
  final CourseTeacher teacher;
  final CourseCategory category;
  final List<CurriculumSectionModel> curriculum;
  final List<CourseReview> reviews;

  const CourseDetailModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.description,
    required this.thumbnailUrl,
    required this.price,
    this.salePrice,
    required this.isFree,
    required this.isFeatured,
    required this.level,
    required this.language,
    required this.durationText,
    required this.averageRating,
    required this.reviewsCount,
    this.progressPercentage,
    required this.isEnrolled,
    required this.teacher,
    required this.category,
    required this.curriculum,
    required this.reviews,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>;
    return CourseDetailModel(
      id: d['id'],
      title: d['title'] ?? '',
      subtitle: d['subtitle'] ?? '',
      description: d['description'],
      thumbnailUrl: d['thumbnail_url'] ?? '',
      price: (d['price'] ?? 0).toDouble(),
      salePrice: d['sale_price'] != null ? (d['sale_price']).toDouble() : null,
      isFree: d['is_free'] ?? false,
      isFeatured: d['is_featured'] ?? false,
      level: d['level'] ?? '',
      language: d['language'] ?? '',
      durationText: d['duration_text'] ?? '',
      averageRating: (d['average_rating'] ?? 0).toDouble(),
      reviewsCount: d['reviews_count'] ?? 0,
      progressPercentage: d['progress_percentage'] != null
          ? double.tryParse(d['progress_percentage'].toString())
          : null,
      isEnrolled: d['is_enrolled'] ?? false,
      teacher: CourseTeacher.fromJson(d['teacher'] as Map<String, dynamic>),
      category: CourseCategory.fromJson(d['category'] as Map<String, dynamic>),
      curriculum: d['curriculum'] != null
          ? (d['curriculum'] as List)
              .map((e) => CurriculumSectionModel.fromJson(e))
              .toList()
          : [],
      reviews: d['reviews'] != null
          ? (d['reviews'] as List)
              .map((e) => CourseReview.fromJson(e))
              .toList()
          : [],
    );
  }
}

class CurriculumSectionModel {
  final int id;
  final String title;
  final int order;
  final List<LessonItemModel> lessons;

  const CurriculumSectionModel({
    required this.id,
    required this.title,
    required this.order,
    required this.lessons,
  });

  factory CurriculumSectionModel.fromJson(Map<String, dynamic> json) =>
      CurriculumSectionModel(
        id: json['id'],
        title: json['title'] ?? '',
        order: json['order'] ?? 0,
        lessons: json['lessons'] != null
            ? (json['lessons'] as List)
                .map((e) => LessonItemModel.fromJson(e))
                .toList()
            : [],
      );
}

class LessonItemModel {
  final int id;
  final String title;
  final String type;
  final String? durationText;
  final bool isFree;
  final bool isCompleted;
  final bool isLocked;

  const LessonItemModel({
    required this.id,
    required this.title,
    required this.type,
    this.durationText,
    required this.isFree,
    required this.isCompleted,
    required this.isLocked,
  });

  factory LessonItemModel.fromJson(Map<String, dynamic> json) =>
      LessonItemModel(
        id: json['id'],
        title: json['title'] ?? '',
        type: json['type'] ?? 'video',
        durationText: json['duration_text'],
        isFree: json['is_free'] ?? false,
        isCompleted: json['is_completed'] ?? false,
        isLocked: json['is_locked'] ?? false,
      );
}

class CourseReview {
  final int id;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String? comment;
  final String createdAt;

  const CourseReview({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory CourseReview.fromJson(Map<String, dynamic> json) => CourseReview(
        id: json['id'],
        userName: json['user_name'] ?? '',
        userAvatar: json['user_avatar'],
        rating: (json['rating'] ?? 0).toDouble(),
        comment: json['comment'],
        createdAt: json['created_at'] ?? '',
      );
}
