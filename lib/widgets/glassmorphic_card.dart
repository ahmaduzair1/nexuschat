import 'dart:ui';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// A frosted glass surface widget with configurable blur, border, and radius.
///
/// Used across settings cards, input bar, nav bar, and modals.
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double opacity;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.blur = 20,
    this.borderColor,
    this.borderWidth = 0.5,
    this.borderRadius,
    this.padding,
    this.backgroundColor,
    this.opacity = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppSpacing.borderRadiusLg;
    final border = borderColor ?? AppColors.silverFaint.withOpacity(0.3);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (backgroundColor ?? AppColors.graphiteSurface).withOpacity(opacity),
            borderRadius: radius,
            border: Border.all(
              color: border,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
