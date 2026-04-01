class AssignmentApiModel {
  final int id;
  final String title;
  final String? description;
  final String? instructions;
  final String dueAt;
  final int maxMarks;
  final String submissionType;
  final String status;
  final AssignmentCourse course;
  final AssignmentSubmission? submission;

  const AssignmentApiModel({
    required this.id,
    required this.title,
    this.description,
    this.instructions,
    required this.dueAt,
    required this.maxMarks,
    required this.submissionType,
    required this.status,
    required this.course,
    this.submission,
  });

  bool get isSubmitted => submission != null;
  bool get isGraded => submission?.status == 'graded';
  bool get isPastDue => DateTime.tryParse(dueAt)?.isBefore(DateTime.now()) ?? false;

  factory AssignmentApiModel.fromJson(Map<String, dynamic> json) =>
      AssignmentApiModel(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'],
        instructions: json['instructions'],
        dueAt: json['due_at'] ?? '',
        maxMarks: json['max_marks'] ?? 0,
        submissionType: json['submission_type'] ?? 'file',
        status: json['status'] ?? '',
        course: AssignmentCourse.fromJson(
            json['course'] as Map<String, dynamic>),
        submission: json['submission'] != null
            ? AssignmentSubmission.fromJson(
                json['submission'] as Map<String, dynamic>)
            : null,
      );
}

class AssignmentCourse {
  final int id;
  final String title;
  const AssignmentCourse({required this.id, required this.title});
  factory AssignmentCourse.fromJson(Map<String, dynamic> json) =>
      AssignmentCourse(id: json['id'], title: json['title'] ?? '');
}

class AssignmentSubmission {
  final int id;
  final String status;
  final String? submissionText;
  final String? fileUrl;
  final int? marks;
  final String? remarks;
  final String? submittedAt;
  final String? gradedAt;

  const AssignmentSubmission({
    required this.id,
    required this.status,
    this.submissionText,
    this.fileUrl,
    this.marks,
    this.remarks,
    this.submittedAt,
    this.gradedAt,
  });

  factory AssignmentSubmission.fromJson(Map<String, dynamic> json) =>
      AssignmentSubmission(
        id: json['id'],
        status: json['status'] ?? '',
        submissionText: json['submission_text'],
        fileUrl: json['file_url'],
        marks: json['marks'],
        remarks: json['remarks'],
        submittedAt: json['submitted_at'],
        gradedAt: json['graded_at'],
      );
}
