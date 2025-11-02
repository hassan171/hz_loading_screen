import 'package:flutter/material.dart';

/// Defines the available animation types for loading screen transitions.
///
/// These animations are used for both entrance and exit transitions of the
/// loading screen overlay. Each animation type provides a different visual
/// effect when showing or hiding the loading screen.
///
/// ## Animation Types
///
/// - [fade]: Simple opacity transition (fade in/out)
/// - [slideUp]: Slides in from bottom, slides out to bottom
/// - [slideDown]: Slides in from top, slides out to top
/// - [slideLeft]: Slides in from right, slides out to right
/// - [slideRight]: Slides in from left, slides out to left
/// - [scale]: Scales up from center, scales down to center
/// - [rotation]: Rotates while fading (360° rotation)
/// - [none]: No animation, instant show/hide
///
/// ## Usage
///
/// ```dart
/// HzLoadingData(
///   text: 'Loading...',
///   entranceAnimation: HzLoadingAnimation.scale,
///   exitAnimation: HzLoadingAnimation.fade,
///   animationDuration: Duration(milliseconds: 300),
/// )
/// ```
enum HzLoadingAnimation {
  /// Simple opacity transition (fade in/out).
  ///
  /// The loading screen will fade in when showing and fade out when hiding.
  /// This is a subtle, professional animation suitable for most use cases.
  fade,

  /// Slides in from bottom, slides out to bottom.
  ///
  /// The loading screen will slide up from the bottom of the screen when
  /// showing and slide back down when hiding.
  slideUp,

  /// Slides in from top, slides out to top.
  ///
  /// The loading screen will slide down from the top of the screen when
  /// showing and slide back up when hiding.
  slideDown,

  /// Slides in from right, slides out to right.
  ///
  /// The loading screen will slide in from the right side of the screen
  /// when showing and slide back out to the right when hiding.
  slideLeft,

  /// Slides in from left, slides out to left.
  ///
  /// The loading screen will slide in from the left side of the screen
  /// when showing and slide back out to the left when hiding.
  slideRight,

  /// Scales up from center, scales down to center.
  ///
  /// The loading screen will scale up from a small size in the center when
  /// showing and scale back down when hiding. Creates a "popup" effect.
  scale,

  /// Rotates while fading (360° rotation).
  ///
  /// The loading screen will rotate a full 360 degrees while fading in when
  /// showing and rotate in reverse while fading out when hiding.
  rotation,

  /// No animation, instant show/hide.
  ///
  /// The loading screen will appear and disappear instantly without any
  /// transition animation. Useful for performance-critical situations.
  none,
}

/// Extension methods for [HzLoadingAnimation] to provide animation builders.
extension HzLoadingAnimationExtension on HzLoadingAnimation {
  /// Creates an animated transition widget for the given animation type.
  ///
  /// This method returns a widget builder that creates the appropriate
  /// animation transition based on the animation type.
  ///
  /// ## Parameters
  ///
  /// - [child]: The widget to animate (the loading screen content)
  /// - [animation]: The animation controller value (0.0 to 1.0)
  ///
  /// ## Returns
  ///
  /// A widget that applies the animation transition to the child.
  Widget buildTransition(Widget child, Animation<double> animation) {
    switch (this) {
      case HzLoadingAnimation.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case HzLoadingAnimation.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case HzLoadingAnimation.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case HzLoadingAnimation.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case HzLoadingAnimation.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );

      case HzLoadingAnimation.scale:
        return ScaleTransition(
          scale: animation,
          child: child,
        );

      case HzLoadingAnimation.rotation:
        return RotationTransition(
          turns: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case HzLoadingAnimation.none:
        return child;
    }
  }

  /// Gets the default animation duration for this animation type.
  ///
  /// Different animation types have different optimal durations for the
  /// best visual effect.
  ///
  /// ## Returns
  ///
  /// The recommended duration for this animation type.
  Duration get defaultDuration {
    switch (this) {
      case HzLoadingAnimation.fade:
        return const Duration(milliseconds: 250);
      case HzLoadingAnimation.slideUp:
      case HzLoadingAnimation.slideDown:
      case HzLoadingAnimation.slideLeft:
      case HzLoadingAnimation.slideRight:
        return const Duration(milliseconds: 300);
      case HzLoadingAnimation.scale:
        return const Duration(milliseconds: 200);
      case HzLoadingAnimation.rotation:
        return const Duration(milliseconds: 500);
      case HzLoadingAnimation.none:
        return Duration.zero;
    }
  }

  /// Gets the default animation curve for this animation type.
  ///
  /// Different animation types work better with different easing curves
  /// for a more natural feel.
  ///
  /// ## Returns
  ///
  /// The recommended curve for this animation type.
  Curve get defaultCurve {
    switch (this) {
      case HzLoadingAnimation.fade:
        return Curves.easeInOut;
      case HzLoadingAnimation.slideUp:
      case HzLoadingAnimation.slideDown:
        return Curves.easeOutCubic;
      case HzLoadingAnimation.slideLeft:
      case HzLoadingAnimation.slideRight:
        return Curves.easeOutCubic;
      case HzLoadingAnimation.scale:
        return Curves.easeOutBack;
      case HzLoadingAnimation.rotation:
        return Curves.easeInOut;
      case HzLoadingAnimation.none:
        return Curves.linear;
    }
  }
}
