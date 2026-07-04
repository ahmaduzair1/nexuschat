import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/mock_data.dart';
import '../../widgets/avatar_status_ring.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBackground,
      appBar: AppBar(
        title: Text(
          'Status',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(letterSpacing: -1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 100), // Space for nav bar
        children: [
          // My Status
          _buildSectionTitle(context, 'My Status'),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
            leading: Stack(
              children: [
                AvatarStatusRing(
                  imageUrl: mockUsers[0].avatarUrl, // Assuming current user is Sarah
                  isOnline: false,
                  showRing: false,
                  size: AppSpacing.avatarLg,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.emeraldPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.navyBackground, width: 2),
                    ),
                    child: const Icon(Icons.add_rounded, color: AppColors.navyBackground, size: 16),
                  ),
                ),
              ],
            ),
            title: Text('Add to my status', style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text('Tap to share an update', style: Theme.of(context).textTheme.bodyMedium),
          ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideX(begin: 0.1),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: Divider(),
          ),

          // Recent Updates
          _buildSectionTitle(context, 'Recent Updates'),
          ...mockStatuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              leading: AvatarStatusRing(
                imageUrl: status.user.avatarUrl,
                isOnline: false,
                showRing: true,
                ringWidth: 3,
                ringGradient: status.viewedSegments < status.totalSegments 
                    ? AppColors.storyRingGradient 
                    : const LinearGradient(colors: [AppColors.silverMuted, AppColors.silverMuted]),
                size: AppSpacing.avatarLg,
              ),
              title: Text(status.user.name, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(
                formatTimestamp(status.timestamp), 
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.silverMuted),
              ),
              onTap: () {
                // Placeholder for cinematic viewer
              },
            ).animate()
              .fadeIn(delay: Duration(milliseconds: 50 * index), duration: const Duration(milliseconds: 300))
              .slideX(begin: 0.1, delay: Duration(milliseconds: 50 * index));
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.sm, top: AppSpacing.xs),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.silverMuted,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
