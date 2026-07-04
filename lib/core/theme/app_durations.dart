import 'package:flutter/material.dart';

/// Nexus Chat — Motion System Constants
///
/// Core principle: motion should feel "expensive" not "playful."
/// 180–320ms for UI changes, spring physics for interactions.
abstract final class AppDurations {
  // ── Duration Scale ──
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 380);
  static const Duration spring = Duration(milliseconds: 400);
  static const Duration pageTransition = Duration(milliseconds: 450);
  static const Duration glow = Duration(milliseconds: 1800);

  // ── Stagger Delays ──
  static const Duration staggerChat = Duration(milliseconds: 50);
  static const Duration staggerBubble = Duration(milliseconds: 40);
  static const Duration staggerReaction = Duration(milliseconds: 30);

  // ── Curves ──
  static const Curve curveEaseOut = Curves.easeOutCubic;
  static const Curve curveMedium = Curves.easeOutQuart;
  static const Curve curveSlow = Curves.easeInOutCubic;
  static const Curve curveSpring = Curves.elasticOut;
  static const Curve curveBack = Curves.easeOutBack;
  static const Curve curveBounce = Curves.bounceOut;

  // ── Convenience: Combined animation specs ──
  static const Duration navTransition = Duration(milliseconds: 280);
  static const Duration bubbleEntry = Duration(milliseconds: 200);
  static const Duration swipeAction = Duration(milliseconds: 300);
  static const Duration toggleSwitch = Duration(milliseconds: 200);
}
