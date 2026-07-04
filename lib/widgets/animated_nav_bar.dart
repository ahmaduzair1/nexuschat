import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Bottom navigation bar with fluid morph transitions and emerald glow.
class AnimatedNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(Icons.chat_bubble_rounded, Icons.chat_bubble_outlined, 'Chats'),
    _NavItem(Icons.amp_stories_rounded, Icons.amp_stories_outlined, 'Status'),
    _NavItem(Icons.auto_awesome_rounded, Icons.auto_awesome_outlined, 'AI'),
    _NavItem(Icons.settings_rounded, Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xs,
        top: AppSpacing.sm,
        left: AppSpacing.xl,
        right: AppSpacing.xl,
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.borderRadiusFull,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.graphiteSurface.withOpacity(0.8),
              borderRadius: AppSpacing.borderRadiusFull,
              border: Border.all(
                color: AppColors.silverFaint.withOpacity(0.15),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) {
                final selected = i == currentIndex;
                final item = _items[i];
                return _NavButton(
                  item: item,
                  selected: selected,
                  onTap: () => onTap(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavItem(this.activeIcon, this.inactiveIcon, this.label);
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              transformAlignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(selected ? 1.15 : 1.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow behind icon
                  if (selected)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.emeraldPrimary.withOpacity(0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      selected ? item.activeIcon : item.inactiveIcon,
                      key: ValueKey(selected),
                      color: selected
                          ? AppColors.emeraldPrimary
                          : AppColors.silverMuted,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? AppColors.emeraldPrimary
                    : AppColors.silverMuted,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
