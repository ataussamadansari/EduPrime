class CertificateModel {
  final int id;
  final String title;
  final String certificateCode;
  final String? description;
  final String issueDate;
  final String status;
  final String? fileUrl;
  final String? verificationUrl;
  final CertificateCourse course;

  const CertificateModel({
    required this.id,
    required this.title,
    required this.certificateCode,
    this.description,
    required this.issueDate,
    required this.status,
    this.fileUrl,
    this.verificationUrl,
    required this.course,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      CertificateModel(
        id: json['id'],
        title: json['title'] ?? '',
        certificateCode: json['certificate_code'] ?? '',
        description: json['description'],
        issueDate: json['issue_date'] ?? '',
        status: json['status'] ?? '',
        fileUrl: json['file_url'],
        verificationUrl: json['verification_url'],
        course: CertificateCourse.fromJson(
            json['course'] as Map<String, dynamic>),
      );
}

class CertificateCourse {
  final int id;
  final String title;

  const CertificateCourse({required this.id, required this.title});

  factory CertificateCourse.fromJson(Map<String, dynamic> json) =>
      CertificateCourse(id: json['id'], title: json['title'] ?? '');
}
