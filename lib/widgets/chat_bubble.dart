import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;
  final bool showTail;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const ChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    this.showTail = true,
    this.onDoubleTap,
    this.onLongPress,
  });

  String formatMessageTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    final min = time.minute.toString().padLeft(2, '0');
    return '$hour:$min $amPm';
  }

  @override
  Widget build(BuildContext context) {
    final isSent = message.senderId == currentUserId;
    // Assuming AI messages are sent from a special user ID "u7"
    final isAI = message.senderId == 'u7';

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          margin: EdgeInsets.only(
            left: isSent ? 48 : AppSpacing.lg,
            right: isSent ? AppSpacing.lg : 48,
            top: AppSpacing.xxs,
            bottom: AppSpacing.xxs,
          ),
          child: isAI ? _buildAIBubble(context, isSent) : _buildBubble(context, isSent),
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, bool isSent) {
    final isMedia = message.type == MessageType.image || message.type == MessageType.audio;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMedia ? AppSpacing.xs : AppSpacing.md + 2,
        vertical: isMedia ? AppSpacing.xs : AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        borderRadius: showTail
            ? (isSent ? AppSpacing.bubbleSent : AppSpacing.bubbleReceived)
            : AppSpacing.borderRadiusBubble,
        color: isSent
            ? AppColors.emeraldSubtle.withOpacity(0.9)
            : AppColors.graphiteLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSent ? 0.15 : 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: isSent
            ? Border.all(color: AppColors.emeraldPrimary.withOpacity(0.15), width: 0.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.type == MessageType.image && message.mediaUrl != null)
            ClipRRect(
              borderRadius: AppSpacing.borderRadiusSm,
              child: Image.network(
                message.mediaUrl!,
                width: 240,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 240,
                    height: 240,
                    color: AppColors.graphiteElevated,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.emeraldPrimary,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            )
          else if (message.type == MessageType.audio && message.mediaUrl != null)
            _VoiceNotePlayer(audioUrl: message.mediaUrl!, isSent: isSent)
          else
            Text(
              message.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.silverText,
                    height: 1.4,
                  ),
            ),
          const SizedBox(height: AppSpacing.xs),
          _buildMeta(context, isSent),
        ],
      ),
    );
  }

  Widget _buildAIBubble(BuildContext context, bool isSent) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: showTail ? AppSpacing.bubbleReceived : AppSpacing.borderRadiusBubble,
        gradient: AppColors.premiumGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldPrimary.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.goldAccent.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md + 2,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          borderRadius: showTail
              ? AppSpacing.bubbleReceived.subtract(BorderRadius.circular(2))
              : AppSpacing.borderRadiusBubble.subtract(BorderRadius.circular(2)),
          color: AppColors.graphiteSurface.withOpacity(0.95),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 12,
                  color: AppColors.goldAccent,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Nexus AI',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.goldAccent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.silverText,
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildMeta(context, isSent),
          ],
        ),
      ),
    );
  }

  Widget _buildMeta(BuildContext context, bool isSent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatMessageTime(message.timestamp),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.silverMuted.withOpacity(0.7),
                fontSize: 10,
              ),
        ),
        if (isSent) ...[
          const SizedBox(width: AppSpacing.xs),
          Icon(
            message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
            size: 14,
            color: message.isRead
                ? AppColors.emeraldPrimary
                : AppColors.silverMuted.withOpacity(0.5),
          ),
        ],
      ],
    );
  }
}

class _VoiceNotePlayer extends StatefulWidget {
  final String audioUrl;
  final bool isSent;

  const _VoiceNotePlayer({required this.audioUrl, required this.isSent});

  @override
  State<_VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<_VoiceNotePlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  void _initAudio() async {
    await _audioPlayer.setSourceUrl(widget.audioUrl);
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() => _duration = newDuration);
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() => _position = newPosition);
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: widget.isSent ? AppColors.emeraldDark.withOpacity(0.2) : AppColors.graphiteElevated,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_isPlaying) {
                _audioPlayer.pause();
              } else {
                _audioPlayer.play(UrlSource(widget.audioUrl));
              }
            },
            child: Icon(
              _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              size: 36,
              color: widget.isSent ? AppColors.emeraldPrimary : AppColors.silverText,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                    activeTrackColor: widget.isSent ? AppColors.emeraldPrimary : AppColors.silverText,
                    inactiveTrackColor: AppColors.silverMuted.withOpacity(0.3),
                    thumbColor: widget.isSent ? AppColors.emeraldPrimary : AppColors.silverText,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1,
                    value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
