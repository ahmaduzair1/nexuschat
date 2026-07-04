import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String? statusText;
  final DateTime? lastSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
    this.statusText,
    this.lastSeen,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      isOnline: data['isOnline'] ?? false,
      statusText: data['statusText'],
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'statusText': statusText,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
    };
  }

  UserModel copyWith({
    String? name,
    String? avatarUrl,
    bool? isOnline,
    String? statusText,
    DateTime? lastSeen,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      statusText: statusText ?? this.statusText,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
