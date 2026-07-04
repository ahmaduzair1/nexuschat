import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Floating message input bar with blur backdrop and animated send button.
class MessageInputBar extends StatefulWidget {
  final Function(String)? onSend;
  final VoidCallback? onAttachment;
  final VoidCallback? onMic;

  const MessageInputBar({super.key, this.onSend, this.onAttachment, this.onMic});

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _hasText = false;
  late AnimationController _sendCtrl;
  late Animation<double> _sendScale;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) {
        setState(() => _hasText = has);
        has ? _sendCtrl.forward() : _sendCtrl.reverse();
      }
    });
    _sendCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
    _sendScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _sendCtrl, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    _sendCtrl.dispose();
    super.dispose();
  }

  void _handleSend() {
    final t = _controller.text.trim();
    if (t.isNotEmpty) { widget.onSend?.call(t); _controller.clear(); }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md, right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm),
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusFull,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.graphiteSurface.withOpacity(0.85),
              borderRadius: AppSpacing.borderRadiusFull,
              border: Border.all(
                color: AppColors.silverFaint.withOpacity(0.2), width: 0.5),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20, offset: const Offset(0, -4))],
            ),
            child: Row(children: [
              _iconBtn(Icons.add_rounded, widget.onAttachment),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: TextField(
                controller: _controller,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.silverText),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.silverMuted),
                  filled: false, border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                  isDense: true),
                maxLines: 4, minLines: 1,
                textCapitalization: TextCapitalization.sentences)),
              const SizedBox(width: AppSpacing.xs),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                child: _hasText
                  ? ScaleTransition(scale: _sendScale, child: _sendBtn())
                  : _iconBtn(Icons.mic_rounded, widget.onMic, key: const ValueKey('mic'))),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _sendBtn() => InkWell(
    key: const ValueKey('send'), onTap: _handleSend,
    borderRadius: BorderRadius.circular(100),
    child: Container(width: 40, height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle, gradient: AppColors.emeraldGradient,
        boxShadow: [BoxShadow(
          color: AppColors.emeraldPrimary.withOpacity(0.4),
          blurRadius: 8, offset: const Offset(0, 2))]),
      child: const Icon(Icons.arrow_upward_rounded,
        color: AppColors.navyBackground, size: 20)));

  Widget _iconBtn(IconData icon, VoidCallback? onTap, {Key? key}) => InkWell(
    key: key, onTap: onTap,
    borderRadius: BorderRadius.circular(100),
    child: SizedBox(width: 40, height: 40,
      child: Icon(icon, color: AppColors.silverMuted, size: 22)));
}
