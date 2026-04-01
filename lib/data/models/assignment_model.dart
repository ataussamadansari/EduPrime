enum AssignmentStatus { pending, submitted, graded, overdue }

class AssignmentModel {
  final String id;
  final String title;
  final String courseName;
  final String dueDate;
  final AssignmentStatus status;
  final int? score;
  final int totalMarks;
  final String description;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.courseName,
    required this.dueDate,
    required this.status,
    this.score,
    required this.totalMarks,
    required this.description,
  });
}
