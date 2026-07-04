import 'package:flutter/material.dart';

/// Nexus Chat — Spacing & Radius System
///
/// 4pt base grid. Dense like Telegram but with premium breathing room
/// around key elements.
abstract final class AppSpacing {
  // ── Spacing Scale ──
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;

  // ── Border Radius ──
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusBubble = 18;
  static const double radiusXl = 22;
  static const double radiusFull = 100;

  // ── Convenience BorderRadius ──
  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusBubble = BorderRadius.circular(radiusBubble);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // ── Chat Bubble Specific ──
  static BorderRadius bubbleSent = const BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
    bottomLeft: Radius.circular(18),
    bottomRight: Radius.circular(4),
  );

  static BorderRadius bubbleReceived = const BorderRadius.only(
    topLeft: Radius.circular(4),
    topRight: Radius.circular(18),
    bottomLeft: Radius.circular(18),
    bottomRight: Radius.circular(18),
  );

  // ── Common EdgeInsets ──
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // ── Avatar Sizes ──
  static const double avatarSm = 36;
  static const double avatarMd = 48;
  static const double avatarLg = 56;
  static const double avatarXl = 80;
}
