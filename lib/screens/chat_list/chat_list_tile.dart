import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/models/chat_model.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/avatar_status_ring.dart';

class ChatListTile extends ConsumerStatefulWidget {
  final ChatModel chat;
  final VoidCallback onTap;
  final int index;

  const ChatListTile({
    super.key,
    required this.chat,
    required this.onTap,
    required this.index,
  });

  @override
  ConsumerState<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends ConsumerState<ChatListTile> {
  double _dragExtent = 0;
  static const double _maxDrag = -140;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;
      if (_dragExtent < _maxDrag * 1.2) _dragExtent = _maxDrag * 1.2; // Elastic limit
      if (_dragExtent > 0) _dragExtent = 0;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragExtent < _maxDrag / 2) {
      setState(() => _dragExtent = _maxDrag);
    } else {
      setState(() => _dragExtent = 0);
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) {
      final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
      final amPm = time.hour >= 12 ? 'PM' : 'AM';
      final min = time.minute.toString().padLeft(2, '0');
      return '$hour:$min $amPm';
    }
    if (diff.inDays == 1) return 'Yesterday';
    return '${time.month}/${time.day}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateProvider).value;
    final currentUserId = currentUser?.uid ?? '';
    
    // Find the other participant
    final otherUserId = widget.chat.participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    
    // Stream the other user's data
    final otherUserStream = ref.watch(userStreamProvider(otherUserId));
    
    final unreadCount = widget.chat.unreadCounts[currentUserId] ?? 0;
    final isTyping = widget.chat.typingStatus[otherUserId] ?? false;

    final actions = Positioned.fill(
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.navyBackground,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAction(Icons.push_pin_rounded, AppColors.goldSubtle),
            const SizedBox(width: AppSpacing.sm),
            _buildAction(Icons.archive_rounded, AppColors.emeraldPrimary),
          ],
        ),
      ),
    );

    final tile = Transform.translate(
      offset: Offset(_dragExtent, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_dragExtent != 0) {
              setState(() => _dragExtent = 0);
              return;
            }
            widget.onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                otherUserStream.when(
                  data: (user) => AvatarStatusRing(
                    imageUrl: user?.avatarUrl ?? '',
                    isOnline: user?.isOnline ?? false,
                    heroTag: 'avatar_${widget.chat.id}',
                  ),
                  loading: () => const CircleAvatar(radius: AppSpacing.avatarMd / 2, backgroundColor: AppColors.graphiteLight),
                  error: (_, __) => const CircleAvatar(radius: AppSpacing.avatarMd / 2, backgroundColor: AppColors.errorRed),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: otherUserStream.when(
                              data: (user) => Text(
                                user?.name ?? 'Unknown User',
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              loading: () => Container(width: 100, height: 16, color: AppColors.graphiteLight),
                              error: (_, __) => const Text('Error'),
                            ),
                          ),
                          Text(
                            _formatTime(widget.chat.lastMessageTime),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: unreadCount > 0 ? AppColors.emeraldPrimary : AppColors.silverMuted,
                              fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (isTyping)
                            Text(
                              'typing...',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.emeraldPrimary,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          else
                            Expanded(
                              child: Text(
                                widget.chat.lastMessage,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: unreadCount > 0 ? AppColors.silverText : AppColors.silverMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (unreadCount > 0)
                            Container(
                              margin: const EdgeInsets.only(left: AppSpacing.sm),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.emeraldPrimary,
                                borderRadius: AppSpacing.borderRadiusFull,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.emeraldPrimary.withOpacity(0.4),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  color: AppColors.navyBackground,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [actions, tile],
      ),
    ).animate().slideY(
      begin: 0.2, end: 0,
      duration: const Duration(milliseconds: 280),
      delay: Duration(milliseconds: widget.index * 50),
      curve: Curves.easeOutQuart,
    ).fade(
      duration: const Duration(milliseconds: 280),
      delay: Duration(milliseconds: widget.index * 50),
    );
  }

  Widget _buildAction(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
