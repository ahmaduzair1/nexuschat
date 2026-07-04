import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, audio }

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final MessageType type;
  final String? mediaUrl;
  final DateTime timestamp;
  final bool isRead;
  final String? replyToMessageId;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    this.type = MessageType.text,
    this.mediaUrl,
    required this.timestamp,
    this.isRead = false,
    this.replyToMessageId,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == (data['type'] ?? 'text'),
        orElse: () => MessageType.text,
      ),
      mediaUrl: data['mediaUrl'],
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      replyToMessageId: data['replyToMessageId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'replyToMessageId': replyToMessageId,
    };
  }
}
