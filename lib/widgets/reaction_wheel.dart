import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Radial reaction wheel triggered by long press.
class ReactionWheel extends StatefulWidget {
  final Offset position;
  final VoidCallback onDismiss;
  final ValueChanged<String> onReactionSelected;

  const ReactionWheel({
    super.key,
    required this.position,
    required this.onDismiss,
    required this.onReactionSelected,
  });

  @override
  State<ReactionWheel> createState() => _ReactionWheelState();
}

class _ReactionWheelState extends State<ReactionWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAndFade;
  
  final List<String> _emojis = ['👍', '❤️', '😂', '🔥', '✨', '😢'];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAndFade = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutBack,
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _closeAndSelect(String emoji) async {
    await _ctrl.reverse();
    widget.onReactionSelected(emoji);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen blur dismiss layer
        GestureDetector(
          onTap: () async {
            await _ctrl.reverse();
            widget.onDismiss();
          },
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5 * _ctrl.value,
                  sigmaY: 5 * _ctrl.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.3 * _ctrl.value),
                ),
              );
            },
          ),
        ),
        
        // Reaction container near touch position
        Positioned(
          top: (widget.position.dy - 60).clamp(50.0, MediaQuery.of(context).size.height - 100.0),
          left: (widget.position.dx - 140).clamp(AppSpacing.md, MediaQuery.of(context).size.width - 280.0),
          child: ScaleTransition(
            scale: _scaleAndFade,
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _scaleAndFade,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.graphiteSurface.withOpacity(0.95),
                  borderRadius: AppSpacing.borderRadiusFull,
                  border: Border.all(color: AppColors.silverFaint.withOpacity(0.2), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_emojis.length, (index) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 200 + (index * 50)),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: GestureDetector(
                            onTap: () => _closeAndSelect(_emojis[index]),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                _emojis[index],
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
