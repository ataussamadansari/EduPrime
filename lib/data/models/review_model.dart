class ReviewModel {
  final int id;
  final int rating;
  final String? title;
  final String? review;
  final ReviewStudent student;
  final String createdAt;

  const ReviewModel({
    required this.id,
    required this.rating,
    this.title,
    this.review,
    required this.student,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'],
        rating: json['rating'] ?? 0,
        title: json['title'],
        review: json['review'],
        student: ReviewStudent.fromJson(
            json['student'] as Map<String, dynamic>),
        createdAt: json['created_at'] ?? '',
      );
}

class ReviewStudent {
  final int id;
  final String name;
  final String? avatarUrl;

  const ReviewStudent({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory ReviewStudent.fromJson(Map<String, dynamic> json) => ReviewStudent(
        id: json['id'],
        name: json['name'] ?? '',
        avatarUrl: json['avatar_url'],
      );
}
