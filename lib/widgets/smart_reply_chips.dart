import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// AI smart reply suggestion chips — horizontal scrolling row.
class SmartReplyChips extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String>? onTap;

  const SmartReplyChips({
    super.key,
    required this.suggestions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return _Chip(
            text: suggestions[index],
            onTap: () => onTap?.call(suggestions[index]),
          );
        },
      ),
    );
  }
}

class _Chip extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  const _Chip({required this.text, this.onTap});

  @override
  State<_Chip> createState() => _ChipState();
}

class _ChipState extends State<_Chip> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 250));
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.93), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.93, end: 1.05), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: () { _ctrl.forward(from: 0); widget.onTap?.call(); },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppSpacing.borderRadiusFull,
            color: AppColors.graphiteLight,
            border: Border.all(
              color: AppColors.goldSubtle.withOpacity(0.3), width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded,
                size: 13, color: AppColors.goldSubtle),
              const SizedBox(width: AppSpacing.xs),
              Text(widget.text,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.silverSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
