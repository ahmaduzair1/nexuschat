import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/models/chat_model.dart';
import '../../core/models/message_model.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/storage_provider.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/message_input_bar.dart';
import '../../widgets/smart_reply_chips.dart';
import '../../widgets/typing_indicator.dart';
import '../../widgets/reaction_wheel.dart';
import '../../widgets/shimmer_loader.dart';
import 'chat_app_bar.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final ChatModel chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Reaction state
  Offset? _reactionPosition;
  MessageModel? _messageToReact;
  
  bool _isUploading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) async {
    final currentUserId = ref.read(authStateProvider).value?.uid;
    if (currentUserId == null) return;

    try {
      await ref.read(databaseProvider).sendMessage(
        widget.chat.id,
        currentUserId,
        text,
      );
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  Future<void> _pickImage() async {
    final currentUserId = ref.read(authStateProvider).value?.uid;
    if (currentUserId == null) return;

    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      
      if (image != null) {
        setState(() => _isUploading = true);
        
        final File file = File(image.path);
        final storageService = ref.read(storageProvider);
        final imageUrl = await storageService.uploadImage(file, widget.chat.id);
        
        await ref.read(databaseProvider).sendMessage(
          widget.chat.id,
          currentUserId,
          '🖼️ Image',
          type: MessageType.image,
          mediaUrl: imageUrl,
        );
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  void _recordAudio() async {
    final currentUserId = ref.read(authStateProvider).value?.uid;
    if (currentUserId == null) return;

    try {
      if (await _audioRecorder.hasPermission()) {
        if (_isRecording) {
          final path = await _audioRecorder.stop();
          setState(() => _isRecording = false);
          
          if (path != null) {
            setState(() => _isUploading = true);
            final File file = File(path);
            final storageService = ref.read(storageProvider);
            final audioUrl = await storageService.uploadAudio(file, widget.chat.id);
            
            await ref.read(databaseProvider).sendMessage(
              widget.chat.id,
              currentUserId,
              '🎤 Voice Note',
              type: MessageType.audio,
              mediaUrl: audioUrl,
            );
          }
        } else {
          // Start recording
          setState(() => _isRecording = true);
          final directory = await getTemporaryDirectory();
          final path = '${directory.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: path,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission required.')),
        );
      }
    } catch (e) {
      debugPrint('Error with audio recording: $e');
      setState(() => _isRecording = false);
    } finally {
      if (mounted && !_isRecording) setState(() => _isUploading = false);
    }
  }

  void _openReactionWheel(LongPressStartDetails details, MessageModel message) {
    setState(() {
      _reactionPosition = details.globalPosition;
      _messageToReact = message;
    });
  }

  void _closeReactionWheel() {
    setState(() {
      _reactionPosition = null;
      _messageToReact = null;
    });
  }

  void _onReactionSelected(String reaction) {
    if (_messageToReact != null) {
      // TODO: Update Firestore document with reaction
    }
    _closeReactionWheel();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(authStateProvider).value?.uid ?? '';
    final otherUserId = widget.chat.participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chat.id));
    final isTyping = widget.chat.typingStatus[otherUserId] ?? false;

    return Scaffold(
      backgroundColor: AppColors.navyBackground,
      appBar: ChatAppBar(
        otherUserId: otherUserId,
        isTyping: isTyping,
        onBack: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          // Background subtle gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.surfaceGradient,
              ),
            ),
          ),
          
          Column(
            children: [
              // Message List
              Expanded(
                child: messagesAsync.when(
                  data: (messages) {
                    return ListView.builder(
                      controller: _scrollController,
                      // Reversed so newest messages are at bottom and we scroll up
                      reverse: true,
                      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.md),
                      itemCount: messages.length + (isTyping ? 1 : 0),
                      itemBuilder: (context, i) {
                        // Because reverse: true, index 0 is at bottom
                        if (i == 0 && isTyping) {
                          return const TypingIndicator()
                              .animate()
                              .fade(duration: const Duration(milliseconds: 300))
                              .slideY(begin: 0.2, end: 0);
                        }
                        
                        final actualIndex = isTyping ? i - 1 : i;
                        final msgIndex = messages.length - 1 - actualIndex;
                        final msg = messages[msgIndex];
                        
                        final bool isLastInGroup = msgIndex == messages.length - 1 || 
                                                   messages[msgIndex + 1].senderId != msg.senderId;
                        
                        return GestureDetector(
                          onLongPressStart: (details) => _openReactionWheel(details, msg),
                          child: ChatBubble(
                            message: msg,
                            currentUserId: currentUserId,
                            showTail: isLastInGroup,
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const ShimmerLoader(),
                  error: (e, _) => Center(child: Text('Error loading messages: $e', style: const TextStyle(color: AppColors.errorRed))),
                ),
              ),
              
              if (_isUploading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator(color: AppColors.emeraldPrimary)),
                ),

              // Smart Replies - Display if last message wasn't from current user
              messagesAsync.maybeWhen(
                data: (messages) {
                  if (messages.isNotEmpty && messages.last.senderId != currentUserId && otherUserId != 'u7') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: SmartReplyChips(
                        suggestions: const ['Sounds great! 👍', 'Let me check and get back to you', 'On it!'],
                        onTap: _sendMessage,
                      ).animate().slideY(begin: 1.0, end: 0.0, curve: Curves.easeOutBack, duration: const Duration(milliseconds: 400)).fade(),
                    );
                  }
                  return const SizedBox.shrink();
                },
                orElse: () => const SizedBox.shrink(),
              ),

              // Input Bar
              MessageInputBar(
                onSend: _sendMessage,
                onAttachment: _pickImage,
                onMic: _recordAudio,
              ),
            ],
          ),

          // Reaction Wheel Overlay
          if (_reactionPosition != null)
            ReactionWheel(
              position: _reactionPosition!,
              onDismiss: _closeReactionWheel,
              onReactionSelected: _onReactionSelected,
            ),
        ],
      ),
    );
  }
}
