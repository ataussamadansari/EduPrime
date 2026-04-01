import 'dashboard_model.dart';

class CoursesListModel {
  final List<DashboardCourse> items;
  final PaginationModel pagination;

  const CoursesListModel({required this.items, required this.pagination});

  factory CoursesListModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>;
    return CoursesListModel(
      items: (d['items'] as List)
          .map((e) => DashboardCourse.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(
          d['pagination'] as Map<String, dynamic>),
    );
  }
}

class PaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      PaginationModel(
        currentPage: json['current_page'] ?? 1,
        lastPage: json['last_page'] ?? 1,
        perPage: json['per_page'] ?? 12,
        total: json['total'] ?? 0,
      );

  bool get hasNextPage => currentPage < lastPage;
}
