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
    // Handle both {data: {...}} and flat response
    final d = (json['data'] as Map<String, dynamic>?) ?? json;
    return DashboardModel(
      greeting: d['greeting']?.toString() ?? '',
      profile:
          UserModel.fromJson((d['profile'] as Map<String, dynamic>?) ?? {}),
      notificationUnreadCount:
          (d['notification_unread_count'] as num?)?.toInt() ?? 0,
      quickStats: QuickStats.fromJson(
          (d['quick_stats'] as Map<String, dynamic>?) ?? {}),
      banners: _parseList(d['banners'], BannerModel.fromJson),
      continueLearning:
          _parseList(d['continue_learning'], DashboardCourse.fromJson),
      featuredCourses:
          _parseList(d['featured_courses'], DashboardCourse.fromJson),
    );
  }

  static List<T> _parseList<T>(
      dynamic raw, T Function(Map<String, dynamic>) fromJson) {
    if (raw == null || raw is! List) return [];
    return raw.whereType<Map<String, dynamic>>().map(fromJson).toList();
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
        enrolledCourses: (json['enrolled_courses'] as num?)?.toInt() ?? 0,
        attendancePercentage:
            (json['attendance_percentage'] as num?)?.toDouble() ?? 0.0,
        pendingAssignments: (json['pending_assignments'] as num?)?.toInt() ?? 0,
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
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        subtitle: json['subtitle']?.toString() ?? '',
        imageUrl: json['image_url']?.toString() ?? '',
        actionType: json['action_type']?.toString() ?? '',
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
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        subtitle: json['subtitle']?.toString() ?? '',
        thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        salePrice: json['sale_price'] != null
            ? (json['sale_price'] as num).toDouble()
            : null,
        isFree: json['is_free'] as bool? ?? false,
        level: json['level']?.toString() ?? '',
        language: json['language']?.toString() ?? '',
        durationText: json['duration_text']?.toString() ?? '',
        progressPercentage: json['progress_percentage'] != null
            ? double.tryParse(json['progress_percentage'].toString())
            : null,
        averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
        reviewsCount: (json['reviews_count'] as num?)?.toInt() ?? 0,
        teacher: CourseTeacher.fromJson(
            (json['teacher'] as Map<String, dynamic>?) ?? {}),
        category: CourseCategory.fromJson(
            (json['category'] as Map<String, dynamic>?) ?? {}),
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
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? '',
        headline: json['headline']?.toString(),
        qualification: json['qualification']?.toString(),
        avatarUrl: json['avatar_url']?.toString(),
      );
}

class CourseCategory {
  final int id;
  final String name;

  const CourseCategory({required this.id, required this.name});

  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? '',
      );
}
