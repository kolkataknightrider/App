// ════════════════════════════════════════════════════════════════
// FILE: lib/core/models/notification_model.dart
// FCM notification message — /notifications/{userId}/messages/{msgId}
// ════════════════════════════════════════════════════════════════

import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type; // earning / withdrawal / rank_up / new_member
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(
      Map<String, dynamic> json, String docId) {
    return NotificationModel(
      id: docId,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? 'earning',
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
      createdAt: _dateFromJson(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
        'type': type,
        'isRead': isRead,
        'data': data,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      isRead: isRead ?? this.isRead,
      data: data,
      createdAt: createdAt,
    );
  }

  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }

  @override
  List<Object?> get props => [id, title, type, isRead, createdAt];
}
