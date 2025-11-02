import 'package:flutter/widgets.dart';

/// Defines the positioning options for the loading screen overlay.
///
/// This enum provides predefined positioning options that control where
/// the loading screen appears on the screen.
///
/// ## Available Positions
///
/// - [center]: Centers the loading screen in the middle of the screen (default)
/// - [top]: Positions the loading screen at the top of the screen
/// - [bottom]: Positions the loading screen at the bottom of the screen
/// - [custom]: Allows custom positioning using [Alignment] values
///
/// ## Usage Examples
///
/// Center position (default):
/// ```dart
/// HzLoadingData(
///   text: 'Loading...',
///   position: HzLoadingPosition.center,
/// )
/// ```
///
/// Top position:
/// ```dart
/// HzLoadingData(
///   text: 'Processing...',
///   position: HzLoadingPosition.top,
/// )
/// ```
///
/// Custom position:
/// ```dart
/// HzLoadingData(
///   text: 'Custom...',
///   position: HzLoadingPosition.custom,
///   customAlignment: Alignment.topRight,
/// )
/// ```
enum HzLoadingPosition {
  /// Centers the loading screen in the middle of the screen.
  ///
  /// This is the default position that places the loading content
  /// at the center both horizontally and vertically.
  center,

  /// Positions the loading screen at the top of the screen.
  ///
  /// The loading content will be aligned to the top center of the screen.
  /// Useful for non-intrusive loading indicators.
  top,

  /// Positions the loading screen at the bottom of the screen.
  ///
  /// The loading content will be aligned to the bottom center of the screen.
  /// Good for status updates or progress notifications.
  bottom,

  /// Allows custom positioning using the [customAlignment] property.
  ///
  /// When this position is selected, you must provide a [customAlignment]
  /// value to specify exactly where the loading screen should appear.
  custom,
}

/// Extension methods for [HzLoadingPosition] to provide utility functions.
extension HzLoadingPositionExtension on HzLoadingPosition {
  /// Returns the default [Alignment] for this position.
  ///
  /// This is used when [customAlignment] is not provided or when
  /// the position is not [HzLoadingPosition.custom].
  ///
  /// Returns:
  /// - [Alignment.center] for [center]
  /// - [Alignment.topCenter] for [top]
  /// - [Alignment.bottomCenter] for [bottom]
  /// - [Alignment.center] for [custom] (fallback)
  Alignment get defaultAlignment {
    switch (this) {
      case HzLoadingPosition.center:
        return Alignment.center;
      case HzLoadingPosition.top:
        return Alignment.topCenter;
      case HzLoadingPosition.bottom:
        return Alignment.bottomCenter;
      case HzLoadingPosition.custom:
        return Alignment.center; // Fallback if no custom alignment provided
    }
  }

  /// Returns a human-readable name for this position.
  ///
  /// Useful for debugging and display purposes.
  String get displayName {
    switch (this) {
      case HzLoadingPosition.center:
        return 'Center';
      case HzLoadingPosition.top:
        return 'Top';
      case HzLoadingPosition.bottom:
        return 'Bottom';
      case HzLoadingPosition.custom:
        return 'Custom';
    }
  }
}
