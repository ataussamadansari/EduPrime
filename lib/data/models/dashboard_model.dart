import 'user_model.dart';

class DashboardModel {
  final String greeting;
  final UserModel profile;
  final int notificationUnreadCount;
  final QuickStats quickStats;
  final List<BannerModel> banners;
  final List<DashboardCourse> continueLearning;
  final List<DashboardCourse> featuredCourses;

  const DashboardModel({
    required this.greeting,
    required this.profile,
    required this.notificationUnreadCount,
    required this.quickStats,
    required this.banners,
    required this.continueLearning,
    required this.featuredCourses,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>;
    return DashboardModel(
      greeting: d['greeting'] ?? '',
      profile: UserModel.fromJson(d['profile'] as Map<String, dynamic>),
      notificationUnreadCount: d['notification_unread_count'] ?? 0,
      quickStats: QuickStats.fromJson(
          d['quick_stats'] as Map<String, dynamic>),
      banners: (d['banners'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList(),
      continueLearning: (d['continue_learning'] as List)
          .map((e) => DashboardCourse.fromJson(e))
          .toList(),
      featuredCourses: (d['featured_courses'] as List)
          .map((e) => DashboardCourse.fromJson(e))
          .toList(),
    );
  }
}

class QuickStats {
  final int enrolledCourses;
  final double attendancePercentage;
  final int pendingAssignments;

  const QuickStats({
    required this.enrolledCourses,
    required this.attendancePercentage,
    required this.pendingAssignments,
  });

  factory QuickStats.fromJson(Map<String, dynamic> json) => QuickStats(
        enrolledCourses: json['enrolled_courses'] ?? 0,
        attendancePercentage:
            (json['attendance_percentage'] ?? 0).toDouble(),
        pendingAssignments: json['pending_assignments'] ?? 0,
      );
}

class BannerModel {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String actionType;
  final String actionValue;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.actionType,
    required this.actionValue,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id'],
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        imageUrl: json['image_url'] ?? '',
        actionType: json['action_type'] ?? '',
        actionValue: json['action_value']?.toString() ?? '',
      );
}

class DashboardCourse {
  final int id;
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final double price;
  final double? salePrice;
  final bool isFree;
  final String level;
  final String language;
  final String durationText;
  final double? progressPercentage;
  final double averageRating;
  final int reviewsCount;
  final CourseTeacher teacher;
  final CourseCategory category;

  const DashboardCourse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.price,
    this.salePrice,
    required this.isFree,
    required this.level,
    required this.language,
    required this.durationText,
    this.progressPercentage,
    required this.averageRating,
    required this.reviewsCount,
    required this.teacher,
    required this.category,
  });

  factory DashboardCourse.fromJson(Map<String, dynamic> json) =>
      DashboardCourse(
        id: json['id'],
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        thumbnailUrl: json['thumbnail_url'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        salePrice: json['sale_price'] != null
            ? (json['sale_price']).toDouble()
            : null,
        isFree: json['is_free'] ?? false,
        level: json['level'] ?? '',
        language: json['language'] ?? '',
        durationText: json['duration_text'] ?? '',
        progressPercentage: json['progress_percentage'] != null
            ? (json['progress_percentage']).toDouble()
            : null,
        averageRating: (json['average_rating'] ?? 0).toDouble(),
        reviewsCount: json['reviews_count'] ?? 0,
        teacher:
            CourseTeacher.fromJson(json['teacher'] as Map<String, dynamic>),
        category:
            CourseCategory.fromJson(json['category'] as Map<String, dynamic>),
      );
}

class CourseTeacher {
  final int id;
  final String name;
  final String? headline;
  final String? qualification;
  final String? avatarUrl;

  const CourseTeacher({
    required this.id,
    required this.name,
    this.headline,
    this.qualification,
    this.avatarUrl,
  });

  factory CourseTeacher.fromJson(Map<String, dynamic> json) => CourseTeacher(
        id: json['id'],
        name: json['name'] ?? '',
        headline: json['headline'],
        qualification: json['qualification'],
        avatarUrl: json['avatar_url'],
      );
}

class CourseCategory {
  final int id;
  final String name;

  const CourseCategory({required this.id, required this.name});

  factory CourseCategory.fromJson(Map<String, dynamic> json) =>
      CourseCategory(id: json['id'], name: json['name'] ?? '');
}
