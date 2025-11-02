import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hz_loading_screen/src/hz_loading_config.dart';
import 'package:hz_loading_screen/src/hz_loading_animation.dart';
import 'package:hz_loading_screen/src/hz_loading_position.dart';

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

  /// Whether to show the decoration around the loading content.
  ///
  /// When set to `true`, the decoration (background container) will be shown
  /// even when there's no text. When `false`, the decoration is only shown
  /// when text is present.
  /// Defaults to `false`.
  bool? showDecoration;

  /// Whether to show progress as a linear progress indicator instead of text.
  ///
  /// When set to `true`, progress will be displayed as a LinearProgressIndicator.
  /// When `false` or `null`, progress will be displayed as text percentage.
  /// Only applies when [progress] is provided and [progressBuilder] is not used.
  /// Defaults to `false`.
  bool? useLinearProgress;

  /// Animation type for showing the loading screen.
  ///
  /// Defines how the loading screen should animate when appearing.
  /// If null, uses the global default or [HzLoadingAnimation.fade].
  ///
  /// Available animations:
  /// - [HzLoadingAnimation.fade]: Simple opacity transition
  /// - [HzLoadingAnimation.scale]: Scales up from center
  /// - [HzLoadingAnimation.slideUp]: Slides in from bottom
  /// - [HzLoadingAnimation.slideDown]: Slides in from top
  /// - [HzLoadingAnimation.slideLeft]: Slides in from right
  /// - [HzLoadingAnimation.slideRight]: Slides in from left
  /// - [HzLoadingAnimation.rotation]: Rotates while fading
  /// - [HzLoadingAnimation.none]: No animation
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading...',
  ///   entranceAnimation: HzLoadingAnimation.scale,
  /// )
  /// ```
  HzLoadingAnimation? entranceAnimation;

  /// Animation type for hiding the loading screen.
  ///
  /// Defines how the loading screen should animate when disappearing.
  /// If null, uses the same animation as [entranceAnimation] in reverse.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading...',
  ///   entranceAnimation: HzLoadingAnimation.scale,
  ///   exitAnimation: HzLoadingAnimation.fade,
  /// )
  /// ```
  HzLoadingAnimation? exitAnimation;

  /// Duration of the entrance and exit animations.
  ///
  /// Controls how long the show/hide animations take to complete.
  /// If null, uses the global default or the animation's default duration.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading...',
  ///   animationDuration: Duration(milliseconds: 500),
  /// )
  /// ```
  Duration? animationDuration;

  /// Animation curve for entrance and exit animations.
  ///
  /// Controls the easing function used for animations.
  /// If null, uses the global default or the animation's default curve.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading...',
  ///   animationCurve: Curves.bounceOut,
  /// )
  /// ```
  Curve? animationCurve;

  /// Whether to apply a backdrop blur effect to the background.
  ///
  /// When set to `true`, the content behind the loading screen will be blurred.
  /// This creates a nice visual effect where the background is de-emphasized
  /// while the loading screen is displayed.
  ///
  /// Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Processing...',
  ///   enableBackdropBlur: true,
  ///   backdropBlurSigma: 5.0,
  /// )
  /// ```
  bool? enableBackdropBlur;

  /// The sigma value for the backdrop blur effect.
  ///
  /// Controls the intensity of the blur effect. Higher values create more blur.
  /// Only applies when [enableBackdropBlur] is `true`.
  ///
  /// Typical values:
  /// - `1.0` - Very light blur
  /// - `3.0` - Light blur
  /// - `5.0` - Medium blur (default)
  /// - `10.0` - Heavy blur
  /// - `20.0` - Very heavy blur
  ///
  /// Defaults to `5.0`.
  double? backdropBlurSigma;

  /// Whether to apply a backdrop filter effect to the background.
  ///
  /// When enabled, allows applying various filter effects like brightness,
  /// contrast, saturation adjustments to the background content.
  ///
  /// Defaults to `false`.
  bool? enableBackdropFilter;

  /// Color filter to apply to the background when backdrop filter is enabled.
  ///
  /// Allows applying color transformations to the background content.
  /// Only applies when [enableBackdropFilter] is `true`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   enableBackdropFilter: true,
  ///   backdropColorFilter: ColorFilter.mode(
  ///     Colors.blue.withOpacity(0.2),
  ///     BlendMode.overlay,
  ///   ),
  /// )
  /// ```
  ColorFilter? backdropColorFilter;

  /// Position of the loading screen on the screen.
  ///
  /// Controls where the loading screen appears. Available options:
  /// - [HzLoadingPosition.center]: Centers the loading screen (default)
  /// - [HzLoadingPosition.top]: Positions at the top of the screen
  /// - [HzLoadingPosition.bottom]: Positions at the bottom of the screen
  /// - [HzLoadingPosition.custom]: Uses [customAlignment] for positioning
  ///
  /// Defaults to [HzLoadingPosition.center].
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading...',
  ///   position: HzLoadingPosition.top,
  /// )
  /// ```
  HzLoadingPosition? position;

  /// Custom alignment for the loading screen when [position] is [HzLoadingPosition.custom].
  ///
  /// This parameter is only used when [position] is set to [HzLoadingPosition.custom].
  /// It allows precise control over where the loading screen appears.
  ///
  /// Example alignments:
  /// - [Alignment.topLeft]: Top-left corner
  /// - [Alignment.topRight]: Top-right corner
  /// - [Alignment.centerLeft]: Left center
  /// - [Alignment.centerRight]: Right center
  /// - [Alignment(-0.5, -0.5)]: Custom position
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Custom position...',
  ///   position: HzLoadingPosition.custom,
  ///   customAlignment: Alignment.topRight,
  /// )
  /// ```
  Alignment? customAlignment;

  /// Margin around the loading screen content.
  ///
  /// Adds spacing between the loading screen content and the screen edges.
  /// Useful for preventing the loading screen from touching screen borders
  /// or for creating specific layout spacing.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading...',
  ///   margin: EdgeInsets.all(24),
  /// )
  /// ```
  EdgeInsets? margin;

  /// Maximum width constraint for the loading screen content.
  ///
  /// Limits how wide the loading screen content can be. Useful for
  /// preventing the loading screen from becoming too wide on large screens
  /// or for maintaining consistent sizing across different devices.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading with constrained width...',
  ///   maxWidth: 300,
  /// )
  /// ```
  double? maxWidth;

  /// Maximum height constraint for the loading screen content.
  ///
  /// Limits how tall the loading screen content can be. Useful for
  /// preventing the loading screen from becoming too tall on large screens
  /// or for maintaining consistent sizing across different devices.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading with constrained height...',
  ///   maxHeight: 200,
  /// )
  /// ```
  double? maxHeight;

  /// Whether to automatically hide the loading screen when progress reaches 100%.
  ///
  /// When set to `true`, the loading screen will automatically dismiss itself
  /// when the progress reaches 100%, optionally after a delay specified by [autoHideDelay].
  /// Only applies when [progress] is provided.
  ///
  /// Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// ValueNotifier<int> progress = ValueNotifier<int>(0);
  /// HzLoadingData(
  ///   text: 'Processing...',
  ///   progress: progress,
  ///   autoHideOnComplete: true,
  ///   autoHideDelay: Duration(milliseconds: 500),
  /// )
  /// ```
  bool? autoHideOnComplete;

  /// Delay before automatically hiding the loading screen after completion.
  ///
  /// This delay is applied after the progress reaches 100% and [autoHideOnComplete] is `true`.
  /// Allows users to see the completed state briefly before the loading screen disappears.
  ///
  /// If not specified, the loading screen will hide immediately upon completion.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   autoHideOnComplete: true,
  ///   autoHideDelay: Duration(seconds: 1), // Show complete state for 1 second
  /// )
  /// ```
  Duration? autoHideDelay;

  /// Callback function called when the loading screen is automatically hidden.
  ///
  /// This function is triggered when the loading screen automatically dismisses itself,
  /// either due to progress completion ([autoHideOnComplete]) or maximum duration timeout ([maxDuration]).
  /// Useful for performing cleanup, navigation, or other actions after auto-dismissal.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   autoHideOnComplete: true,
  ///   onAutoHide: () {
  ///     print('Loading completed automatically');
  ///     // Navigate to next screen or perform cleanup
  ///   },
  /// )
  /// ```
  Function? onAutoHide;

  /// Maximum duration before forcing the loading screen to hide.
  ///
  /// After this time has elapsed, the loading screen will automatically dismiss
  /// regardless of progress or other conditions. This acts as a safety mechanism
  /// to prevent loading screens from staying visible indefinitely.
  ///
  /// When the maximum duration is reached, [onAutoHide] will be called if provided.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingData(
  ///   text: 'Loading...',
  ///   maxDuration: Duration(minutes: 2), // Force hide after 2 minutes
  ///   onAutoHide: () => print('Loading timed out'),
  /// )
  /// ```
  Duration? maxDuration;

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
    this.isVisible = false,
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
    this.showDecoration,
    this.useLinearProgress,
    this.entranceAnimation,
    this.exitAnimation,
    this.animationDuration,
    this.animationCurve,
    this.enableBackdropBlur,
    this.backdropBlurSigma,
    this.enableBackdropFilter,
    this.backdropColorFilter,
    this.position,
    this.customAlignment,
    this.margin,
    this.maxWidth,
    this.maxHeight,
    this.autoHideOnComplete,
    this.autoHideDelay,
    this.onAutoHide,
    this.maxDuration,
  });

  /// Creates a new [HzLoadingData] instance with default configuration applied.
  ///
  /// This factory constructor applies the global default values from
  /// [HzLoadingConfig.instance] to any properties that are not explicitly provided.
  ///
  /// Individual parameters will still override the defaults when specified.
  ///
  /// ## Example
  ///
  /// Using global defaults:
  /// ```dart
  /// // Assumes you've configured HzLoadingConfig.instance.defaultText = 'Please wait...'
  /// HzLoadingData.withDefaults() // Will use 'Please wait...' as text
  /// ```
  ///
  /// Overriding specific values:
  /// ```dart
  /// HzLoadingData.withDefaults(
  ///   text: 'Custom text', // Overrides the default text
  ///   progressColor: Colors.red, // Overrides the default progress color
  /// )
  /// ```
  factory HzLoadingData.withDefaults({
    bool? isVisible,
    bool? withTimer,
    Duration? duration,
    Function? onClosed,
    String? text,
    Widget Function(String title)? textBuilder,
    ValueListenable<int>? progress,
    Color? materialColor,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    Widget Function()? progressIndicatorBuilder,
    Color? progressColor,
    IconData? closeIcon,
    Color? closeIconColor,
    Widget Function(int progress)? progressBuilder,
    TextStyle? textStyle,
    TextStyle? progressTextStyle,
    bool? showProgressIndicator,
    bool? showDecoration,
    bool? useLinearProgress,
    HzLoadingAnimation? entranceAnimation,
    HzLoadingAnimation? exitAnimation,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableBackdropBlur,
    double? backdropBlurSigma,
    bool? enableBackdropFilter,
    ColorFilter? backdropColorFilter,
    HzLoadingPosition? position,
    Alignment? customAlignment,
    EdgeInsets? margin,
    double? maxWidth,
    double? maxHeight,
    bool? autoHideOnComplete,
    Duration? autoHideDelay,
    Function? onAutoHide,
    Duration? maxDuration,
  }) {
    final config = HzLoadingConfig.instance;

    return HzLoadingData(
      isVisible: isVisible ?? false,
      withTimer: withTimer ?? config.withTimer ?? true,
      duration: duration ?? config.displayDuration,
      onClosed: onClosed ?? config.onClosed,
      text: text ?? config.defaultText,
      textBuilder: textBuilder ?? config.textBuilder,
      progress: progress,
      materialColor: materialColor ?? config.materialColor,
      padding: padding ?? config.padding,
      decoration: decoration ?? config.decoration,
      progressIndicatorBuilder: progressIndicatorBuilder ?? config.progressIndicatorBuilder,
      progressColor: progressColor ?? config.progressColor,
      closeIcon: closeIcon ?? config.closeIcon,
      closeIconColor: closeIconColor ?? config.closeIconColor,
      progressBuilder: progressBuilder ?? config.progressBuilder,
      textStyle: textStyle ?? config.textStyle,
      progressTextStyle: progressTextStyle ?? config.progressTextStyle,
      showProgressIndicator: showProgressIndicator ?? config.showProgressIndicator,
      showDecoration: showDecoration ?? config.showDecoration,
      useLinearProgress: useLinearProgress ?? config.useLinearProgress,
      entranceAnimation: entranceAnimation ?? config.entranceAnimation,
      exitAnimation: exitAnimation ?? config.exitAnimation,
      animationDuration: animationDuration ?? config.animationDuration,
      animationCurve: animationCurve ?? config.animationCurve,
      enableBackdropBlur: enableBackdropBlur ?? config.enableBackdropBlur,
      backdropBlurSigma: backdropBlurSigma ?? config.backdropBlurSigma,
      enableBackdropFilter: enableBackdropFilter ?? config.enableBackdropFilter,
      backdropColorFilter: backdropColorFilter ?? config.backdropColorFilter,
      position: position ?? config.position,
      customAlignment: customAlignment ?? config.customAlignment,
      margin: margin ?? config.margin,
      maxWidth: maxWidth ?? config.maxWidth,
      maxHeight: maxHeight ?? config.maxHeight,
      autoHideOnComplete: autoHideOnComplete ?? config.autoHideOnComplete,
      autoHideDelay: autoHideDelay ?? config.autoHideDelay,
      onAutoHide: onAutoHide ?? config.onAutoHide,
      maxDuration: maxDuration ?? config.maxDuration,
    );
  }

  HzLoadingData copyWith({
    bool? isVisible,
    bool? withTimer,
    Duration? duration,
    Function? onClosed,
    String? text,
    Widget Function(String title)? textBuilder,
    ValueListenable<int>? progress,
    Color? materialColor,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
    Widget Function()? progressIndicatorBuilder,
    Color? progressColor,
    IconData? closeIcon,
    Color? closeIconColor,
    Widget Function(int progress)? progressBuilder,
    TextStyle? textStyle,
    TextStyle? progressTextStyle,
    bool? showProgressIndicator,
    bool? showDecoration,
    bool? useLinearProgress,
    HzLoadingAnimation? entranceAnimation,
    HzLoadingAnimation? exitAnimation,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableBackdropBlur,
    double? backdropBlurSigma,
    bool? enableBackdropFilter,
    ColorFilter? backdropColorFilter,
    HzLoadingPosition? position,
    Alignment? customAlignment,
    EdgeInsets? margin,
    double? maxWidth,
    double? maxHeight,
    bool? autoHideOnComplete,
    Duration? autoHideDelay,
    Function? onAutoHide,
    Duration? maxDuration,
  }) {
    return HzLoadingData(
      isVisible: isVisible ?? this.isVisible,
      withTimer: withTimer ?? this.withTimer,
      duration: duration ?? this.duration,
      onClosed: onClosed ?? this.onClosed,
      text: text ?? this.text,
      textBuilder: textBuilder ?? this.textBuilder,
      progress: progress ?? this.progress,
      materialColor: materialColor ?? this.materialColor,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      progressIndicatorBuilder: progressIndicatorBuilder ?? this.progressIndicatorBuilder,
      progressColor: progressColor ?? this.progressColor,
      closeIcon: closeIcon ?? this.closeIcon,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      progressBuilder: progressBuilder ?? this.progressBuilder,
      textStyle: textStyle ?? this.textStyle,
      progressTextStyle: progressTextStyle ?? this.progressTextStyle,
      showProgressIndicator: showProgressIndicator ?? this.showProgressIndicator,
      showDecoration: showDecoration ?? this.showDecoration,
      useLinearProgress: useLinearProgress ?? this.useLinearProgress,
      entranceAnimation: entranceAnimation ?? this.entranceAnimation,
      exitAnimation: exitAnimation ?? this.exitAnimation,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableBackdropBlur: enableBackdropBlur ?? this.enableBackdropBlur,
      backdropBlurSigma: backdropBlurSigma ?? this.backdropBlurSigma,
      enableBackdropFilter: enableBackdropFilter ?? this.enableBackdropFilter,
      backdropColorFilter: backdropColorFilter ?? this.backdropColorFilter,
      position: position ?? this.position,
      customAlignment: customAlignment ?? this.customAlignment,
      margin: margin ?? this.margin,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      autoHideOnComplete: autoHideOnComplete ?? this.autoHideOnComplete,
      autoHideDelay: autoHideDelay ?? this.autoHideDelay,
      onAutoHide: onAutoHide ?? this.onAutoHide,
      maxDuration: maxDuration ?? this.maxDuration,
    );
  }
}
