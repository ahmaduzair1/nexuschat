import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/database_provider.dart';
import '../../widgets/avatar_status_ring.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String otherUserId;
  final bool isTyping;
  final VoidCallback onBack;

  const ChatAppBar({
    super.key,
    required this.otherUserId,
    required this.isTyping,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherUserStream = ref.watch(userStreamProvider(otherUserId));

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AppColors.navyBackground.withOpacity(0.85),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Back Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.silverText, size: 20),
                  ),
                ),
              ),

              // Avatar
              otherUserStream.when(
                data: (user) => AvatarStatusRing(
                  imageUrl: user?.avatarUrl ?? '',
                  size: 40,
                  isOnline: user?.isOnline ?? false,
                  showRing: true,
                  ringWidth: 2,
                  heroTag: 'avatar_$otherUserId',
                ),
                loading: () => const CircleAvatar(radius: 20, backgroundColor: AppColors.graphiteLight),
                error: (_, __) => const CircleAvatar(radius: 20, backgroundColor: AppColors.errorRed),
              ),
              
              const SizedBox(width: AppSpacing.md),

              // Name & Status
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: otherUserStream.when(
                            data: (user) => Text(
                              user?.name ?? 'Unknown User',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            loading: () => Container(width: 80, height: 16, color: AppColors.graphiteLight),
                            error: (_, __) => const Text('Error'),
                          ),
                        ),
                        if (otherUserId == 'u7') // AI Badge
                          Container(
                            margin: const EdgeInsets.only(left: AppSpacing.xs),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.goldSubtle.withOpacity(0.2),
                              border: Border.all(color: AppColors.goldAccent.withOpacity(0.5)),
                              borderRadius: AppSpacing.borderRadiusSm,
                            ),
                            child: const Text(
                              'AI',
                              style: TextStyle(
                                color: AppColors.goldAccent,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (isTyping)
                      Text(
                        'typing...',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.emeraldPrimary,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else 
                      otherUserStream.maybeWhen(
                        data: (user) {
                          if (user == null) return const SizedBox.shrink();
                          return Text(
                            user.statusText ?? (user.isOnline ? 'Online' : 'Offline'),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: user.isOnline ? AppColors.emeraldPrimary : AppColors.silverMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),

              // Actions
              if (otherUserId != 'u7')
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {}, // Summarize action
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Icon(Icons.auto_awesome_rounded, color: AppColors.goldSubtle, size: 22),
                    ),
                  ),
                ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Icon(Icons.videocam_rounded, color: AppColors.silverText, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
