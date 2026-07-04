import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'auth_provider.dart';

final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService(ref);
});

final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  
  return ref.watch(databaseProvider).getUserStream(user.uid);
});

final userChatsProvider = StreamProvider<List<ChatModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  
  return ref.watch(databaseProvider).getUserChats(user.uid);
});

final chatMessagesProvider = StreamProvider.family<List<MessageModel>, String>((ref, chatId) {
  return ref.watch(databaseProvider).getChatMessages(chatId);
});

final userStreamProvider = StreamProvider.family<UserModel?, String>((ref, uid) {
  if (uid.isEmpty) return Stream.value(null);
  return ref.watch(databaseProvider).getUserStream(uid);
});

class DatabaseService {
  final Ref ref;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseService(this.ref);

  // ── Users ──
  Future<void> createUserDocument(String uid, String name, String email) async {
    final user = UserModel(
      id: uid,
      name: name,
      avatarUrl: 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=00C896&color=0A0E1A',
      isOnline: true,
      lastSeen: DateTime.now(),
    );
    await _firestore.collection('users').doc(uid).set(user.toMap());
  }

  Stream<UserModel?> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data()!, doc.id);
    });
  }

  Future<void> updateUserStatus(String uid, bool isOnline) async {
    await _firestore.collection('users').doc(uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  // ── Chats ──
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // ── Messages ──
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MessageModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> sendMessage(String chatId, String senderId, String text, {MessageType type = MessageType.text, String? mediaUrl}) async {
    final message = MessageModel(
      id: '',
      senderId: senderId,
      text: text,
      type: type,
      mediaUrl: mediaUrl,
      timestamp: DateTime.now(),
    );

    final docRef = _firestore.collection('chats').doc(chatId).collection('messages').doc();
    
    // Batch write to update message and lastMessage in chat document
    final batch = _firestore.batch();
    
    batch.set(docRef, message.toMap());
    batch.update(_firestore.collection('chats').doc(chatId), {
      'lastMessage': type == MessageType.text ? text : '🖼️ Media',
      'lastMessageTime': FieldValue.serverTimestamp(),
      // In a real app, increment unread count for other participants here
    });

    await batch.commit();
  }
}
