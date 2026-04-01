class AttendanceSummary {
  final int presentCount;
  final int absentCount;
  final double attendancePercentage;

  const AttendanceSummary({
    required this.presentCount,
    required this.absentCount,
    required this.attendancePercentage,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>;
    return AttendanceSummary(
      presentCount: d['present_count'] ?? 0,
      absentCount: d['absent_count'] ?? 0,
      attendancePercentage: (d['attendance_percentage'] ?? 0).toDouble(),
    );
  }
}

class AttendanceRecord {
  final DateTime date;
  final String status; // 'present' | 'absent'
  final AttendanceCourse course;
  final String? remarks;

  const AttendanceRecord({
    required this.date,
    required this.status,
    required this.course,
    this.remarks,
  });

  bool get isPresent => status == 'present';

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        date: DateTime.parse(json['date']),
        status: json['status'] ?? 'absent',
        course: AttendanceCourse.fromJson(
            json['course'] as Map<String, dynamic>),
        remarks: json['remarks'],
      );
}

class AttendanceCourse {
  final int id;
  final String title;

  const AttendanceCourse({required this.id, required this.title});

  factory AttendanceCourse.fromJson(Map<String, dynamic> json) =>
      AttendanceCourse(id: json['id'], title: json['title'] ?? '');
}
