import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Circular avatar with animated gradient ring for online status.
///
/// Supports small (chat list), medium (chat detail), and large (profile) sizes.
class AvatarStatusRing extends StatefulWidget {
  final String imageUrl;
  final double size;
  final bool isOnline;
  final bool showRing;
  final double ringWidth;
  final Gradient? ringGradient;
  final String? heroTag;

  const AvatarStatusRing({
    super.key,
    required this.imageUrl,
    this.size = AppSpacing.avatarMd,
    this.isOnline = false,
    this.showRing = true,
    this.ringWidth = 2.5,
    this.ringGradient,
    this.heroTag,
  });

  @override
  State<AvatarStatusRing> createState() => _AvatarStatusRingState();
}

class _AvatarStatusRingState extends State<AvatarStatusRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isOnline) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AvatarStatusRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOnline && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isOnline && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarWidget = _buildAvatar();

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: avatarWidget,
      );
    }
    return avatarWidget;
  }

  Widget _buildAvatar() {
    final totalSize = widget.size + (widget.showRing ? widget.ringWidth * 2 + 4 : 0);

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ring
          if (widget.showRing && widget.isOnline)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: totalSize,
                  height: totalSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.ringGradient ?? AppColors.statusRingGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emeraldPrimary.withOpacity(0.3 * _pulseAnimation.value),
                        blurRadius: 8 * _pulseAnimation.value,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              },
            )
          else if (widget.showRing)
            Container(
              width: totalSize,
              height: totalSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.silverFaint.withOpacity(0.3),
              ),
            ),

          // Avatar image
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.graphiteLight,
              border: Border.all(
                color: AppColors.navyBackground,
                width: widget.showRing ? 2 : 0,
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.graphiteLight,
                  child: Icon(
                    Icons.person_rounded,
                    size: widget.size * 0.5,
                    color: AppColors.silverMuted,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.graphiteLight,
                  child: Icon(
                    Icons.person_rounded,
                    size: widget.size * 0.5,
                    color: AppColors.silverMuted,
                  ),
                ),
              ),
            ),
          ),

          // Online dot indicator
          if (widget.isOnline)
            Positioned(
              right: widget.showRing ? 2 : 0,
              bottom: widget.showRing ? 2 : 0,
              child: Container(
                width: widget.size * 0.24,
                height: widget.size * 0.24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emeraldPrimary,
                  border: Border.all(
                    color: AppColors.navyBackground,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emeraldPrimary.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
