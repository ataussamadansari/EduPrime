class SupportTicketModel {
  final int id;
  final String subject;
  final String message;
  final String category;
  final String priority;
  final String status;
  final String? attachmentUrl;
  final String? adminReply;
  final String? repliedAt;
  final String createdAt;

  const SupportTicketModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.category,
    required this.priority,
    required this.status,
    this.attachmentUrl,
    this.adminReply,
    this.repliedAt,
    required this.createdAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) =>
      SupportTicketModel(
        id: json['id'],
        subject: json['subject'] ?? '',
        message: json['message'] ?? '',
        category: json['category'] ?? '',
        priority: json['priority'] ?? '',
        status: json['status'] ?? '',
        attachmentUrl: json['attachment_url'],
        adminReply: json['admin_reply'],
        repliedAt: json['replied_at'],
        createdAt: json['created_at'] ?? '',
      );
}
