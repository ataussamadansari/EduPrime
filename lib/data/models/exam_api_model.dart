import 'dashboard_model.dart';

class ExamApiModel {
  final int id;
  final String title;
  final String? description;
  final String examDate;
  final String startTime;
  final String endTime;
  final int durationMinutes;
  final String mode;
  final String? platformName;
  final String? meetingLink;
  final String? venue;
  final String? instructions;
  final String status;
  final CourseTeacher teacher;
  final ExamCourse course;
  final ExamResult? result;

  const ExamApiModel({
    required this.id,
    required this.title,
    this.description,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.mode,
    this.platformName,
    this.meetingLink,
    this.venue,
    this.instructions,
    required this.status,
    required this.teacher,
    required this.course,
    this.result,
  });

  bool get isCompleted => status == 'completed';
  bool get isScheduled => status == 'scheduled';

  factory ExamApiModel.fromJson(Map<String, dynamic> json) => ExamApiModel(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'],
        examDate: json['exam_date'] ?? '',
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        durationMinutes: json['duration_minutes'] ?? 0,
        mode: json['mode'] ?? '',
        platformName: json['platform_name'],
        meetingLink: json['meeting_link'],
        venue: json['venue'],
        instructions: json['instructions'],
        status: json['status'] ?? '',
        teacher: CourseTeacher.fromJson(
            json['teacher'] as Map<String, dynamic>),
        course: ExamCourse.fromJson(
            json['course'] as Map<String, dynamic>),
        result: json['result'] != null
            ? ExamResult.fromJson(json['result'] as Map<String, dynamic>)
            : null,
      );
}

class ExamCourse {
  final int id;
  final String title;
  const ExamCourse({required this.id, required this.title});
  factory ExamCourse.fromJson(Map<String, dynamic> json) =>
      ExamCourse(id: json['id'], title: json['title'] ?? '');
}

class ExamResult {
  final int marksObtained;
  final int maxMarks;
  final double percentage;
  final String grade;
  final String? remarks;
  final String resultStatus;

  const ExamResult({
    required this.marksObtained,
    required this.maxMarks,
    required this.percentage,
    required this.grade,
    this.remarks,
    required this.resultStatus,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) => ExamResult(
        marksObtained: json['marks_obtained'] ?? 0,
        maxMarks: json['max_marks'] ?? 0,
        percentage: (json['percentage'] ?? 0).toDouble(),
        grade: json['grade'] ?? '',
        remarks: json['remarks'],
        resultStatus: json['result_status'] ?? '',
      );
}
