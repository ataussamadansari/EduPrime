class CourseModel {
  final String id;
  final String title;
  final String instructor;
  final String thumbnail;
  final double price;
  final double rating;
  final int reviewCount;
  final String duration;
  final String category;
  final String description;
  final List<CurriculumSection> curriculum;
  final List<ReviewModel> reviews;
  final bool isEnrolled;
  final double progress; // 0.0 to 1.0
  final String lastAccessed;
  final int totalLessons;
  final int completedLessons;

  const CourseModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.duration,
    required this.category,
    required this.description,
    required this.curriculum,
    required this.reviews,
    this.isEnrolled = false,
    this.progress = 0.0,
    this.lastAccessed = '',
    required this.totalLessons,
    this.completedLessons = 0,
  });
}

class CurriculumSection {
  final String title;
  final List<LessonModel> lessons;

  const CurriculumSection({required this.title, required this.lessons});
}

class LessonModel {
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;

  const LessonModel({
    required this.title,
    required this.duration,
    this.isCompleted = false,
    this.isLocked = false,
  });
}

class ReviewModel {
  final String name;
  final double rating;
  final String comment;
  final String date;
  final String avatar;

  const ReviewModel({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
    required this.avatar,
  });
}
