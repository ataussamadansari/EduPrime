class CourseCategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int coursesCount;

  const CourseCategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.coursesCount,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) =>
      CourseCategoryModel(
        id: json['id'],
        name: json['name'] ?? '',
        description: json['description'],
        imageUrl: json['image_url'],
        coursesCount: json['courses_count'] ?? 0,
      );
}
