import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Configuration class for customizing the appearance and behavior of the loading screen.
///
/// This class contains all the properties needed to configure how the loading screen
/// looks and behaves. You can customize everything from colors and text to progress
/// indicators and close button behavior.
///
/// ## Example Usage
///
/// ### Simple loading with text:
/// ```dart
/// HzLoadingData(
///   text: 'Loading, please wait...',
///   withTimer: false,
/// )
/// ```
///
/// ### Custom styled loading:
/// ```dart
/// HzLoadingData(
///   text: 'Processing...',
///   materialColor: Colors.black.withAlpha(150),
///   decoration: BoxDecoration(
///     color: Colors.white,
///     borderRadius: BorderRadius.circular(12),
///   ),
///   progressColor: Colors.blue,
/// )
/// ```
///
/// ### Loading with progress:
/// ```dart
/// ValueNotifier<int> progress = ValueNotifier<int>(0);
/// HzLoadingData(
///   text: 'Downloading...',
///   progress: progress,
///   withTimer: false,
/// )
/// ```
class HzLoadingData {
  /// Whether the loading screen should be visible.
  ///
  /// When set to `false`, the loading screen will be hidden.
  /// Defaults to `true`.
  bool isVisible;

  /// Whether to show a close button after the specified [duration].
  ///
  /// When `true`, a close button will appear after [duration] has elapsed,
  /// allowing users to manually dismiss the loading screen.
  /// Defaults to `true`.
  bool withTimer;

  /// The duration to wait before showing the close button.
  ///
  /// Only applicable when [withTimer] is `true`. After this duration,
  /// a close button will appear allowing users to dismiss the loading screen.
  /// If not specified, defaults to 2 seconds.
  Duration? duration;

  /// Callback function called when the loading screen is closed by the user.
  ///
  /// This function is triggered when the user taps the close button.
  /// Useful for performing cleanup or handling user-initiated dismissals.
  Function? onClosed;

  /// The text to display in the loading screen.
  ///
  /// If `null`, no text will be shown. Can be used in combination with
  /// [textBuilder] for more complex text layouts.
  String? text;

  /// Custom widget builder for displaying text.
  ///
  /// This function receives the [text] parameter and should return a widget
  /// to display. Useful for creating custom text layouts, adding icons,
  /// or applying complex styling.
  ///
  /// Example:
  /// ```dart
  /// textBuilder: (title) => Column(
  ///   children: [
  ///     Icon(Icons.download),
  ///     SizedBox(height: 8),
  ///     Text(title, style: TextStyle(fontSize: 18)),
  ///   ],
  /// )
  /// ```
  Widget Function(String title)? textBuilder;

  /// Progress value notifier for displaying loading progress.
  ///
  /// Should contain values from 0 to 100 representing the completion percentage.
  /// When provided, progress information will be displayed alongside the loading indicator.
  ///
  /// Example:
  /// ```dart
  /// ValueNotifier<int> progress = ValueNotifier<int>(0);
  /// // Update progress: progress.value = 50;
  /// ```
  ValueListenable<int>? progress;

  /// Background color for the overlay that covers the entire screen.
  ///
  /// This is the semi-transparent background that appears behind the loading widget.
  /// Defaults to `Colors.black.withAlpha(150)` if not specified.
  Color? materialColor;

  /// Padding around the loading content container.
  ///
  /// Controls the internal spacing of the loading widget container.
  /// Defaults to `EdgeInsets.all(16)` if not specified.
  EdgeInsetsGeometry? padding;

  /// Decoration for the loading content container.
  ///
  /// Used to style the container that holds the loading indicator and text.
  /// Can include background color, border radius, shadows, etc.
  /// If not provided, a default white container with rounded corners will be used
  /// when text is present, or transparent when no text is shown.
  BoxDecoration? decoration;

  /// Custom builder for the progress indicator widget.
  ///
  /// Allows complete customization of the progress indicator appearance.
  /// If not provided, a default [CircularProgressIndicator] will be used.
  ///
  /// Example:
  /// ```dart
  /// progressIndicatorBuilder: () => CircularProgressIndicator(
  ///   strokeWidth: 6,
  ///   color: Colors.red,
  /// )
  /// ```
  Widget Function()? progressIndicatorBuilder;

  /// Color for the default progress indicator.
  ///
  /// Only applies when using the default progress indicator (when
  /// [progressIndicatorBuilder] is not provided).
  /// Defaults to `Colors.blue`.
  Color? progressColor;

  /// Icon to use for the close button.
  ///
  /// Only shown when [withTimer] is `true` and the timer duration has elapsed.
  /// Defaults to `Icons.close`.
  IconData? closeIcon;

  /// Color for the close button icon.
  ///
  /// Defaults to `Colors.blue`.
  Color? closeIconColor;

  /// Custom builder for displaying progress information.
  ///
  /// This function receives the current progress value (0-100) and should
  /// return a widget to display the progress. Useful for creating custom
  /// progress displays like linear progress bars or custom percentage layouts.
  ///
  /// Example:
  /// ```dart
  /// progressBuilder: (progress) => Column(
  ///   children: [
  ///     LinearProgressIndicator(value: progress / 100),
  ///     Text('$progress% completed'),
  ///   ],
  /// )
  /// ```
  Widget Function(int progress)? progressBuilder;

  /// Text style for the main loading text.
  ///
  /// Applied to the text specified in the [text] property.
  /// Only used when [textBuilder] is not provided.
  TextStyle? textStyle;

  /// Text style for the progress percentage text.
  ///
  /// Applied to the default progress text (e.g., "50%").
  /// Only used when [progressBuilder] is not provided and [progress] is specified.
  TextStyle? progressTextStyle;

  /// Whether to show the progress indicator.
  ///
  /// When set to `false`, the progress indicator (spinner) will be hidden,
  /// showing only text and progress information if provided.
  /// Defaults to `true`.
  bool? showProgressIndicator;

  /// Creates a new [HzLoadingData] instance with the specified configuration.
  ///
  /// All parameters are optional and have sensible defaults. You can customize
  /// any aspect of the loading screen by providing the appropriate parameters.
  ///
  /// ## Example
  ///
  /// Basic loading screen:
  /// ```dart
  /// HzLoadingData(text: 'Loading...')
  /// ```
  ///
  /// Custom styled loading:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Processing...',
  ///   materialColor: Colors.black54,
  ///   decoration: BoxDecoration(
  ///     color: Colors.white,
  ///     borderRadius: BorderRadius.circular(8),
  ///   ),
  /// )
  /// ```
  HzLoadingData({
    this.isVisible = true,
    this.withTimer = true,
    this.duration,
    this.onClosed,
    this.text,
    this.textBuilder,
    this.progress,
    this.materialColor,
    this.padding,
    this.decoration,
    this.progressIndicatorBuilder,
    this.progressColor,
    this.closeIcon,
    this.closeIconColor,
    this.progressBuilder,
    this.textStyle,
    this.progressTextStyle,
    this.showProgressIndicator,
  });
}
