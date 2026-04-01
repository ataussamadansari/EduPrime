enum ExamStatus { upcoming, ongoing, completed }

class ExamModel {
  final String id;
  final String title;
  final String courseName;
  final String date;
  final String time;
  final String duration;
  final ExamStatus status;
  final int? score;
  final int totalMarks;
  final String venue;

  const ExamModel({
    required this.id,
    required this.title,
    required this.courseName,
    required this.date,
    required this.time,
    required this.duration,
    required this.status,
    this.score,
    required this.totalMarks,
    required this.venue,
  });
}
