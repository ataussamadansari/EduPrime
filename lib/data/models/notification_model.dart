class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final String audience;
  final String? actionLabel;
  final String? actionUrl;
  final bool isRead;
  final String? readAt;
  final String publishedAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.audience,
    this.actionLabel,
    this.actionUrl,
    required this.isRead,
    this.readAt,
    required this.publishedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        type: json['type'] ?? '',
        audience: json['audience'] ?? '',
        actionLabel: json['action_label'],
        actionUrl: json['action_url'],
        isRead: json['is_read'] ?? false,
        readAt: json['read_at'],
        publishedAt: json['published_at'] ?? '',
      );

  NotificationModel copyWith({bool? isRead, String? readAt}) =>
      NotificationModel(
        id: id,
        title: title,
        message: message,
        type: type,
        audience: audience,
        actionLabel: actionLabel,
        actionUrl: actionUrl,
        isRead: isRead ?? this.isRead,
        readAt: readAt ?? this.readAt,
        publishedAt: publishedAt,
      );
}
