import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/database_provider.dart';
import '../../widgets/shimmer_loader.dart';
import '../chat_detail/chat_detail_screen.dart';
import 'chat_list_tile.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  bool _showFab = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showFab) setState(() => _showFab = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_showFab) setState(() => _showFab = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsyncValue = ref.watch(userChatsProvider);

    return Scaffold(
      backgroundColor: AppColors.navyBackground,
      body: Stack(
        children: [
          // Main List
          RefreshIndicator(
            color: AppColors.emeraldPrimary,
            backgroundColor: AppColors.graphiteSurface,
            onRefresh: () async {
              // Not necessary for streams, but keeps the UI interaction
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                _buildAppBar(),
                chatsAsyncValue.when(
                  data: (chats) {
                    if (chats.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No chats yet. Start a new conversation!',
                            style: TextStyle(color: AppColors.silverMuted),
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.only(bottom: 100), // Space for nav bar
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ChatListTile(
                              chat: chats[index],
                              index: index,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => 
                                        ChatDetailScreen(chat: chats[index]),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                    transitionDuration: const Duration(milliseconds: 380),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: chats.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(child: ShimmerLoader()),
                  error: (err, stack) => SliverFillRemaining(
                    child: Center(
                      child: Text('Error loading chats: $err', style: const TextStyle(color: AppColors.errorRed)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // FAB
          Positioned(
            bottom: 80, // Above nav bar
            right: AppSpacing.lg,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              offset: _showFab ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _showFab ? 1.0 : 0.0,
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.emeraldGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emeraldPrimary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // TODO: Implement "New Chat" logic (Phase 4)
                      },
                      borderRadius: BorderRadius.circular(28),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: AppColors.navyBackground,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.navyBackground.withOpacity(0.9),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Nexus',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.silverText,
                    letterSpacing: -1,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIconAction(Icons.search_rounded),
                    const SizedBox(width: AppSpacing.sm),
                    _buildIconAction(Icons.more_horiz_rounded),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconAction(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.graphiteLight,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: AppColors.silverText),
    );
  }
}
