import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Animated typing indicator with pulsing emerald glow orbs.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          left: AppSpacing.lg,
          top: AppSpacing.xxs,
          bottom: AppSpacing.xxs,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          borderRadius: AppSpacing.bubbleReceived,
          color: AppColors.graphiteLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) {
                // Offset the animation for each dot
                final double t = (_ctrl.value - (index * 0.2)) % 1.0;
                final double opacity = t < 0 ? 0.3 : (t > 0.5 ? 0.3 : 0.3 + (0.7 * (1 - ((t - 0.25).abs() * 4))));
                final double scale = t < 0 ? 0.8 : (t > 0.5 ? 0.8 : 0.8 + (0.4 * (1 - ((t - 0.25).abs() * 4))));

                return Transform.scale(
                  scale: scale.clamp(0.8, 1.2),
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emeraldPrimary.withOpacity(opacity.clamp(0.3, 1.0)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emeraldGlow.withOpacity((opacity - 0.3).clamp(0.0, 1.0) * 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
