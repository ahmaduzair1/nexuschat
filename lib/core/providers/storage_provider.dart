import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final storageProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<String> uploadImage(File file, String chatId) async {
    try {
      final fileName = '${_uuid.v4()}.jpg';
      final ref = _storage.ref().child('chats/$chatId/images/$fileName');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String> uploadAudio(File file, String chatId) async {
    try {
      final fileName = '${_uuid.v4()}.m4a';
      final ref = _storage.ref().child('chats/$chatId/audio/$fileName');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'audio/mp4'),
      );
      
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload audio: $e');
    }
  }

  Future<String> uploadStatusIndicator(File file, String userId) async {
    try {
      final fileName = '${_uuid.v4()}.jpg';
      final ref = _storage.ref().child('status/$userId/$fileName');
      
      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload status image: $e');
    }
  }
}
