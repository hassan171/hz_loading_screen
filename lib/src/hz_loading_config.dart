import 'package:flutter/material.dart';
import 'package:hz_loading_screen/src/hz_loading_animation.dart';
import 'package:hz_loading_screen/src/hz_loading_position.dart';

/// Global configuration class for Hz Loading Screen default values.
///
/// This class allows you to set default values that will be applied to all
/// loading screens unless explicitly overridden in individual [HzLoadingData] instances.
///
/// ## Usage
///
/// Configure default values once, typically in your app's initialization:
///
/// ```dart
/// void main() {
///   // Configure defaults
///   HzLoadingConfig.instance
///     ..displayDuration = Duration(seconds: 3)
///     ..defaultText = 'Please wait...'
///     ..materialColor = Colors.black.withAlpha(100)
///     ..progressColor = Colors.blue
///     ..textStyle = TextStyle(fontSize: 16, color: Colors.white)
///     ..decoration = BoxDecoration(
///       color: Colors.black87,
///       borderRadius: BorderRadius.circular(8),
///     );
///
///   runApp(MyApp());
/// }
/// ```
///
/// ## Properties
///
/// All properties are optional and have sensible defaults. When a property
/// is null, the hardcoded default will be used. When set, this value becomes
/// the new default for all loading screens.
///
/// Individual [HzLoadingData] instances can still override these defaults
/// by explicitly setting their own values.
class HzLoadingConfig {
  /// Private singleton instance.
  static final HzLoadingConfig _instance = HzLoadingConfig._internal();

  /// Gets the singleton instance for configuration.
  ///
  /// Use this to set default values:
  /// ```dart
  /// HzLoadingConfig.instance
  ///   ..materialColor = Colors.blue.withAlpha(100)
  ///   ..progressColor = Colors.white;
  /// ```
  static HzLoadingConfig get instance => _instance;

  /// Private constructor for singleton pattern.
  HzLoadingConfig._internal();

  /// Default duration before close button appears when [withTimer] is true.
  ///
  /// If null, uses the hardcoded default of 2 seconds.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.displayDuration = Duration(seconds: 5);
  /// ```
  Duration? displayDuration;

  /// Default text to show in loading screens when no text is specified.
  ///
  /// If null, no text will be shown by default.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.defaultText = 'Loading...';
  /// ```
  String? defaultText;

  /// Default background overlay color for the entire screen.
  ///
  /// If null, uses the hardcoded default of `Colors.black.withAlpha(150)`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.materialColor = Colors.blue.withAlpha(100);
  /// ```
  Color? materialColor;

  /// Default padding around the loading content container.
  ///
  /// If null, uses the hardcoded default of `EdgeInsets.all(16)`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.padding = EdgeInsets.all(24);
  /// ```
  EdgeInsetsGeometry? padding;

  /// Default decoration for the loading content container.
  ///
  /// If null, uses a dynamic default based on whether text is present.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.decoration = BoxDecoration(
  ///   color: Colors.white,
  ///   borderRadius: BorderRadius.circular(12),
  ///   boxShadow: [
  ///     BoxShadow(color: Colors.black26, blurRadius: 10),
  ///   ],
  /// );
  /// ```
  BoxDecoration? decoration;

  /// Default color for progress indicators (circular and linear).
  ///
  /// If null, uses the hardcoded default of `Colors.blue`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.progressColor = Colors.green;
  /// ```
  Color? progressColor;

  /// Default text style for the main loading text.
  ///
  /// If null, uses the hardcoded default style.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.textStyle = TextStyle(
  ///   fontSize: 18,
  ///   fontWeight: FontWeight.w600,
  ///   color: Colors.white,
  /// );
  /// ```
  TextStyle? textStyle;

  /// Default text style for progress percentage text.
  ///
  /// If null, uses the hardcoded default style.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.progressTextStyle = TextStyle(
  ///   fontSize: 14,
  ///   color: Colors.grey[600],
  /// );
  /// ```
  TextStyle? progressTextStyle;

  /// Default close button icon.
  ///
  /// If null, uses the hardcoded default of `Icons.close`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.closeIcon = Icons.clear;
  /// ```
  IconData? closeIcon;

  /// Default close button icon color.
  ///
  /// If null, uses the hardcoded default of `Colors.blue`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.closeIconColor = Colors.red;
  /// ```
  Color? closeIconColor;

  /// Default setting for whether to show progress indicators.
  ///
  /// If null, uses the hardcoded default of `true`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.showProgressIndicator = false;
  /// ```
  bool? showProgressIndicator;

  /// Default setting for whether to show timer-based close button.
  ///
  /// If null, uses the hardcoded default of `true`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.withTimer = false;
  /// ```
  bool? withTimer;

  /// Default setting for whether to show decoration around loading content.
  ///
  /// When set to `true`, the decoration (background container) will be shown
  /// even when there's no text. When `false`, the decoration is only shown
  /// when text is present.
  /// If null, uses the hardcoded default of `false`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.showDecoration = true;
  /// ```
  bool? showDecoration;

  /// Default setting for whether to use linear progress indicator.
  ///
  /// When set to `true`, progress will be displayed as a LinearProgressIndicator
  /// instead of text percentage. Only applies when progress is provided and
  /// progressBuilder is not used.
  /// If null, uses the hardcoded default of `false`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.useLinearProgress = true;
  /// ```
  bool? useLinearProgress;

  /// Default entrance animation for loading screens.
  ///
  /// Defines how loading screens should animate when appearing.
  /// If null, uses the hardcoded default of [HzLoadingAnimation.fade].
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.entranceAnimation = HzLoadingAnimation.scale;
  /// ```
  HzLoadingAnimation? entranceAnimation;

  /// Default exit animation for loading screens.
  ///
  /// Defines how loading screens should animate when disappearing.
  /// If null, uses the same animation as [entranceAnimation] in reverse.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.exitAnimation = HzLoadingAnimation.fade;
  /// ```
  HzLoadingAnimation? exitAnimation;

  /// Default animation duration for loading screen transitions.
  ///
  /// Controls how long the show/hide animations take to complete.
  /// If null, uses the animation's default duration.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.animationDuration = Duration(milliseconds: 400);
  /// ```
  Duration? animationDuration;

  /// Default animation curve for loading screen transitions.
  ///
  /// Controls the easing function used for animations.
  /// If null, uses the animation's default curve.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.animationCurve = Curves.easeOutBack;
  /// ```
  Curve? animationCurve;

  /// Default callback function for when loading is closed by user.
  ///
  /// This will be called for all loading screens that don't specify
  /// their own [onClosed] callback.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.onClosed = () {
  ///   print('Loading was dismissed by user');
  /// };
  /// ```
  Function? onClosed;

  /// Default progress indicator builder function.
  ///
  /// If set, this builder will be used for all loading screens unless
  /// they specify their own [progressIndicatorBuilder].
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.progressIndicatorBuilder = () {
  ///   return CircularProgressIndicator(
  ///     strokeWidth: 3,
  ///     color: Colors.white,
  ///   );
  /// };
  /// ```
  Widget Function()? progressIndicatorBuilder;

  /// Default text builder function.
  ///
  /// If set, this builder will be used for all loading screens unless
  /// they specify their own [textBuilder].
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.textBuilder = (text) {
  ///   return Column(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       Icon(Icons.hourglass_bottom, color: Colors.white),
  ///       SizedBox(height: 8),
  ///       Text(text, style: TextStyle(color: Colors.white)),
  ///     ],
  ///   );
  /// };
  /// ```
  Widget Function(String text)? textBuilder;

  /// Default progress builder function.
  ///
  /// If set, this builder will be used for all loading screens unless
  /// they specify their own [progressBuilder].
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.progressBuilder = (progress) {
  ///   return Text(
  ///     '$progress% completed',
  ///     style: TextStyle(color: Colors.white, fontSize: 12),
  ///   );
  /// };
  /// ```
  Widget Function(int progress)? progressBuilder;

  /// Default setting for backdrop blur effect.
  ///
  /// When set to `true`, the content behind the loading screen will be blurred.
  /// If null, uses the hardcoded default of `false`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.enableBackdropBlur = true;
  /// ```
  bool? enableBackdropBlur;

  /// Default sigma value for backdrop blur effect.
  ///
  /// Controls the intensity of the blur effect. Higher values create more blur.
  /// Only applies when [enableBackdropBlur] is `true`.
  /// If null, uses the hardcoded default of `5.0`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.backdropBlurSigma = 10.0;
  /// ```
  double? backdropBlurSigma;

  /// Default setting for backdrop filter effect.
  ///
  /// When enabled, allows applying various filter effects to the background.
  /// If null, uses the hardcoded default of `false`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.enableBackdropFilter = true;
  /// ```
  bool? enableBackdropFilter;

  /// Default color filter for backdrop effect.
  ///
  /// Allows applying color transformations to the background content.
  /// Only applies when [enableBackdropFilter] is `true`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.backdropColorFilter = ColorFilter.mode(
  ///   Colors.blue.withOpacity(0.2),
  ///   BlendMode.overlay,
  /// );
  /// ```
  ColorFilter? backdropColorFilter;

  /// Default position for loading screens.
  ///
  /// Controls where loading screens appear on the screen by default.
  /// If null, uses the hardcoded default of [HzLoadingPosition.center].
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.position = HzLoadingPosition.top;
  /// ```
  HzLoadingPosition? position;

  /// Default custom alignment for loading screens when position is custom.
  ///
  /// Only applies when [position] is set to [HzLoadingPosition.custom].
  /// If null, uses [Alignment.center] as fallback.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance
  ///   ..position = HzLoadingPosition.custom
  ///   ..customAlignment = Alignment.topRight;
  /// ```
  Alignment? customAlignment;

  /// Default margin around loading screen content.
  ///
  /// Adds spacing between the loading screen and screen edges by default.
  /// If null, no default margin is applied.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.margin = EdgeInsets.all(20);
  /// ```
  EdgeInsets? margin;

  /// Default maximum width constraint for loading screen content.
  ///
  /// Limits how wide the loading screen content can be by default.
  /// If null, no width constraint is applied.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.maxWidth = 320;
  /// ```
  double? maxWidth;

  /// Default maximum height constraint for loading screen content.
  ///
  /// Limits how tall the loading screen content can be by default.
  /// If null, no height constraint is applied.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.maxHeight = 240;
  /// ```
  double? maxHeight;

  /// Default setting for auto-hiding when progress reaches 100%.
  ///
  /// When set to `true`, loading screens will automatically dismiss themselves
  /// when progress reaches 100%. Only applies when progress is provided.
  /// If null, uses the hardcoded default of `false`.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.autoHideOnComplete = true;
  /// ```
  bool? autoHideOnComplete;

  /// Default delay before auto-hiding after progress completion.
  ///
  /// Applied after progress reaches 100% and [autoHideOnComplete] is `true`.
  /// If null, loading screens will hide immediately upon completion.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.autoHideDelay = Duration(milliseconds: 500);
  /// ```
  Duration? autoHideDelay;

  /// Default callback for when loading screens auto-hide.
  ///
  /// Called when loading screens automatically dismiss due to progress
  /// completion or maximum duration timeout.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.onAutoHide = () {
  ///   print('Loading completed automatically');
  /// };
  /// ```
  Function? onAutoHide;

  /// Default maximum duration before forcing loading screens to hide.
  ///
  /// After this time, loading screens will automatically dismiss regardless
  /// of progress or other conditions. Acts as a safety mechanism.
  /// If null, no maximum duration is enforced.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.maxDuration = Duration(minutes: 2);
  /// ```
  Duration? maxDuration;

  /// Resets all configuration values to their defaults (null).
  ///
  /// This will cause the hardcoded defaults to be used again.
  ///
  /// Example:
  /// ```dart
  /// HzLoadingConfig.instance.reset();
  /// ```
  void reset() {
    displayDuration = null;
    defaultText = null;
    materialColor = null;
    padding = null;
    decoration = null;
    progressColor = null;
    textStyle = null;
    progressTextStyle = null;
    closeIcon = null;
    closeIconColor = null;
    showProgressIndicator = null;
    withTimer = null;
    showDecoration = null;
    useLinearProgress = null;
    entranceAnimation = null;
    exitAnimation = null;
    animationDuration = null;
    animationCurve = null;
    onClosed = null;
    progressIndicatorBuilder = null;
    textBuilder = null;
    progressBuilder = null;
    enableBackdropBlur = null;
    backdropBlurSigma = null;
    enableBackdropFilter = null;
    backdropColorFilter = null;
    position = null;
    customAlignment = null;
    margin = null;
    maxWidth = null;
    maxHeight = null;
    autoHideOnComplete = null;
    autoHideDelay = null;
    onAutoHide = null;
    maxDuration = null;
  }

  /// Creates a copy of the current configuration.
  ///
  /// Useful for backing up current settings before making changes.
  ///
  /// Example:
  /// ```dart
  /// final backup = HzLoadingConfig.instance.copy();
  /// // Make changes...
  /// // Restore later:
  /// HzLoadingConfig.instance
  ///   ..displayDuration = backup.displayDuration
  ///   ..materialColor = backup.materialColor;
  /// ```
  HzLoadingConfig copy() {
    final copy = HzLoadingConfig._internal();
    copy.displayDuration = displayDuration;
    copy.defaultText = defaultText;
    copy.materialColor = materialColor;
    copy.padding = padding;
    copy.decoration = decoration;
    copy.progressColor = progressColor;
    copy.textStyle = textStyle;
    copy.progressTextStyle = progressTextStyle;
    copy.closeIcon = closeIcon;
    copy.closeIconColor = closeIconColor;
    copy.showProgressIndicator = showProgressIndicator;
    copy.withTimer = withTimer;
    copy.showDecoration = showDecoration;
    copy.useLinearProgress = useLinearProgress;
    copy.entranceAnimation = entranceAnimation;
    copy.exitAnimation = exitAnimation;
    copy.animationDuration = animationDuration;
    copy.animationCurve = animationCurve;
    copy.onClosed = onClosed;
    copy.progressIndicatorBuilder = progressIndicatorBuilder;
    copy.textBuilder = textBuilder;
    copy.progressBuilder = progressBuilder;
    copy.enableBackdropBlur = enableBackdropBlur;
    copy.backdropBlurSigma = backdropBlurSigma;
    copy.enableBackdropFilter = enableBackdropFilter;
    copy.backdropColorFilter = backdropColorFilter;
    copy.position = position;
    copy.customAlignment = customAlignment;
    copy.margin = margin;
    copy.maxWidth = maxWidth;
    copy.maxHeight = maxHeight;
    copy.autoHideOnComplete = autoHideOnComplete;
    copy.autoHideDelay = autoHideDelay;
    copy.onAutoHide = onAutoHide;
    copy.maxDuration = maxDuration;
    return copy;
  }
}
