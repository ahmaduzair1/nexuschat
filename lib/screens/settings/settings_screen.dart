import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/mock_data.dart';
import '../../widgets/avatar_status_ring.dart';
import '../../widgets/glassmorphic_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockUsers[0]; // Current user placeholder

    return Scaffold(
      backgroundColor: AppColors.navyBackground,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(letterSpacing: -1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.md,
          bottom: 120, // Nav bar space
        ),
        children: [
          // Profile Card
          GlassmorphicCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                AvatarStatusRing(
                  imageUrl: user.avatarUrl,
                  size: AppSpacing.avatarXl,
                  showRing: false,
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.statusText ?? 'Available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.emeraldPrimary),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.qr_code_rounded, color: AppColors.silverText),
              ],
            ),
          ).animate().fadeIn(duration: const Duration(milliseconds: 300)).slideY(begin: 0.1),

          const SizedBox(height: AppSpacing.xl),

          // AI Premium Features Section
          _buildSectionHeader(context, 'Nexus Intelligence'),
          GlassmorphicCard(
            borderColor: AppColors.goldSubtle.withOpacity(0.5),
            backgroundColor: AppColors.goldSubtle.withOpacity(0.05),
            child: Column(
              children: [
                _buildSettingTile(
                  context,
                  icon: Icons.auto_awesome_rounded,
                  iconColor: AppColors.goldAccent,
                  title: 'Smart Reply Suggestions',
                  subtitle: 'AI generated context-aware replies',
                  trailing: const _ToggleSwitch(value: true),
                ),
                const Divider(height: 1),
                _buildSettingTile(
                  context,
                  icon: Icons.summarize_rounded,
                  iconColor: AppColors.goldAccent,
                  title: 'Auto-Summarize Long Chats',
                  trailing: const _ToggleSwitch(value: true),
                ),
              ],
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 100)).slideY(begin: 0.1),

          const SizedBox(height: AppSpacing.xl),

          // General Settings
          _buildSectionHeader(context, 'General'),
          GlassmorphicCard(
            child: Column(
              children: [
                _buildSettingTile(
                  context,
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  trailing: const _ToggleSwitch(value: true),
                ),
                const Divider(height: 1),
                _buildSettingTile(
                  context,
                  icon: Icons.notifications_rounded,
                  title: 'Notifications & Sounds',
                ),
                const Divider(height: 1),
                _buildSettingTile(
                  context,
                  icon: Icons.lock_rounded,
                  title: 'Privacy & Security',
                ),
                const Divider(height: 1),
                _buildSettingTile(
                  context,
                  icon: Icons.data_usage_rounded,
                  title: 'Storage & Data',
                ),
              ],
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.silverMuted,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.silverText).withOpacity(0.1),
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Icon(icon, color: iconColor ?? AppColors.silverText, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.bodyMedium) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.silverMuted),
      onTap: trailing is _ToggleSwitch ? null : () {},
    );
  }
}

class _ToggleSwitch extends StatefulWidget {
  final bool value;
  const _ToggleSwitch({required this.value});

  @override
  State<_ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<_ToggleSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: (val) => setState(() => _value = val),
      activeColor: AppColors.emeraldPrimary,
      activeTrackColor: AppColors.emeraldSubtle,
      inactiveTrackColor: AppColors.graphiteLight,
      inactiveThumbColor: AppColors.silverMuted,
    );
  }
}
