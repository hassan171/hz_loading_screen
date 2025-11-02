import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hz_loading_screen/hz_loading_screen.dart';
import 'package:hz_loading_screen/src/hz_loading_animation.dart';
import 'package:hz_loading_screen/src/hz_loading_position.dart';

/// Internal widget that renders the loading screen overlay with animations.
///
/// This widget is responsible for displaying the actual loading screen UI
/// based on the configuration provided through [HzLoadingData]. It listens
/// to changes in the loading state and updates the display accordingly.
///
/// ## Internal Use Only
///
/// This widget is used internally by [HzLoadingInitializer] and should not
/// be used directly in your app code. Use [HzLoading.show] and
/// [HzLoading.hide] instead.
///
/// ## Features
///
/// - Responsive to [HzLoadingData] changes via [ValueListenableBuilder]
/// - Supports custom progress indicators, text builders, and styling
/// - Implements timer-based close button functionality
/// - Handles progress display with both default and custom builders
/// - Manages overlay visibility and animations
/// - Supports entrance and exit animations
///
/// ## Architecture
///
/// The widget uses a [ValueListenableBuilder] to listen for changes in
/// [HzLoading.data] and rebuilds the UI accordingly. When the loading
/// screen is not visible, it returns [SizedBox.shrink] to minimize overhead.
/// Animations are handled using [AnimatedSwitcher] with custom transitions.
class HzLoadingWidget extends StatefulWidget {
  /// Creates a new [HzLoadingWidget].
  ///
  /// This constructor is used internally and should not be called directly.
  const HzLoadingWidget({super.key});

  @override
  State<HzLoadingWidget> createState() => _HzLoadingWidgetState();
}

/// State class for [HzLoadingWidget] that manages animations.
class _HzLoadingWidgetState extends State<HzLoadingWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HzLoadingData>(
      valueListenable: HzLoading.data,
      builder: (context, value, child) {
        return IgnorePointer(
          ignoring: !value.isVisible,
          child: _BackdropEffectWrapper(
            enableBackdropBlur: value.enableBackdropBlur ?? HzLoadingConfig.instance.enableBackdropBlur ?? false,
            backdropBlurSigma: value.backdropBlurSigma ?? HzLoadingConfig.instance.backdropBlurSigma ?? 5.0,
            enableBackdropFilter: value.enableBackdropFilter ?? HzLoadingConfig.instance.enableBackdropFilter ?? false,
            backdropColorFilter: value.backdropColorFilter ?? HzLoadingConfig.instance.backdropColorFilter,
            materialColor:
                value.isVisible ? (value.materialColor ?? HzLoadingConfig.instance.materialColor ?? Colors.black.withAlpha(100)) : Colors.transparent,
            child: AnimatedSwitcher(
              duration: value.animationDuration ?? value.entranceAnimation?.defaultDuration ?? const Duration(milliseconds: 250),
              switchInCurve: value.animationCurve ?? value.entranceAnimation?.defaultCurve ?? Curves.easeInOut,
              switchOutCurve: value.animationCurve ?? value.exitAnimation?.defaultCurve ?? value.entranceAnimation?.defaultCurve ?? Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Get the animation type to use
                final animationType = value.isVisible
                    ? value.entranceAnimation ?? HzLoadingAnimation.fade
                    : value.exitAnimation ?? value.entranceAnimation ?? HzLoadingAnimation.fade;

                return animationType.buildTransition(child, animation);
              },
              child: value.isVisible == false ? const SizedBox.shrink() : _LoadingContent(key: ValueKey('loading-${value.hashCode}'), data: value),
            ),
          ),
        );
      },
    );
  }
}

/// Internal widget that applies backdrop blur and filter effects.
///
/// This widget wraps the loading content and applies backdrop blur and color
/// filter effects when enabled.
class _BackdropEffectWrapper extends StatelessWidget {
  /// Whether to apply backdrop blur effect.
  final bool enableBackdropBlur;

  /// Sigma value for the backdrop blur effect.
  final double backdropBlurSigma;

  /// Whether to apply backdrop filter effect.
  final bool enableBackdropFilter;

  /// Color filter to apply to the background.
  final ColorFilter? backdropColorFilter;

  /// Material color for the background.
  final Color materialColor;

  /// Child widget to wrap.
  final Widget child;

  /// Creates a new [_BackdropEffectWrapper].
  const _BackdropEffectWrapper({
    required this.enableBackdropBlur,
    required this.backdropBlurSigma,
    required this.enableBackdropFilter,
    required this.backdropColorFilter,
    required this.materialColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Material(
      color: materialColor,
      child: child,
    );

    // Apply backdrop filter effects if enabled
    if (enableBackdropFilter && backdropColorFilter != null) {
      content = BackdropFilter(
        filter: backdropColorFilter!,
        child: content,
      );
    }

    // Apply backdrop blur if enabled
    if (enableBackdropBlur) {
      content = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: backdropBlurSigma,
          sigmaY: backdropBlurSigma,
        ),
        child: content,
      );
    }

    return content;
  }
}

/// Internal widget that renders the actual loading content.
///
/// This widget is separated from the main widget to work properly with
/// [AnimatedSwitcher] animations.
class _LoadingContent extends StatefulWidget {
  /// The loading configuration data.
  final HzLoadingData data;

  /// Creates a new [_LoadingContent].
  const _LoadingContent({super.key, required this.data});

  @override
  State<_LoadingContent> createState() => _LoadingContentState();
}

/// State class for [_LoadingContent] that manages auto-dismiss logic.
class _LoadingContentState extends State<_LoadingContent> {
  /// Timer for maximum duration auto-hide.
  Timer? _maxDurationTimer;

  /// Timer for auto-hide delay after completion.
  Timer? _autoHideDelayTimer;

  @override
  void initState() {
    super.initState();
    _setupAutoHideTimers();
  }

  @override
  void didUpdateWidget(_LoadingContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset timers if data changed
    if (oldWidget.data != widget.data) {
      _setupAutoHideTimers();
    }
  }

  @override
  void dispose() {
    _maxDurationTimer?.cancel();
    _autoHideDelayTimer?.cancel();
    super.dispose();
  }

  /// Sets up the auto-hide timers based on current configuration.
  void _setupAutoHideTimers() {
    // Cancel existing timers
    _maxDurationTimer?.cancel();
    _autoHideDelayTimer?.cancel();

    final data = widget.data;
    final config = HzLoadingConfig.instance;

    // Set up maximum duration timer
    final maxDuration = data.maxDuration ?? config.maxDuration;
    if (maxDuration != null) {
      _maxDurationTimer = Timer(maxDuration, () {
        if (mounted) {
          HzLoading.hide();
          (data.onAutoHide ?? config.onAutoHide)?.call();
        }
      });
    }

    // Set up progress completion listener
    if (data.progress != null && (data.autoHideOnComplete ?? config.autoHideOnComplete ?? false)) {
      data.progress!.addListener(_onProgressChanged);
    }
  }

  /// Handles progress changes for auto-hide on completion.
  void _onProgressChanged() {
    final data = widget.data;
    final config = HzLoadingConfig.instance;

    if (data.progress?.value == 100) {
      // Cancel any existing delay timer
      _autoHideDelayTimer?.cancel();

      final autoHideDelay = data.autoHideDelay ?? config.autoHideDelay;
      if (autoHideDelay != null) {
        // Hide after delay
        _autoHideDelayTimer = Timer(autoHideDelay, () {
          if (mounted) {
            HzLoading.hide();
            (data.onAutoHide ?? config.onAutoHide)?.call();
          }
        });
      } else {
        // Hide immediately
        HzLoading.hide();
        (data.onAutoHide ?? config.onAutoHide)?.call();
      }

      // Remove the listener to avoid multiple calls
      data.progress!.removeListener(_onProgressChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    // Determine the alignment based on position
    final position = data.position ?? HzLoadingConfig.instance.position ?? HzLoadingPosition.center;
    final alignment = position == HzLoadingPosition.custom
        ? (data.customAlignment ?? HzLoadingConfig.instance.customAlignment ?? position.defaultAlignment)
        : position.defaultAlignment;

    // Apply margin if specified
    Widget content = Container(
      padding: data.padding ?? const EdgeInsets.all(16),
      decoration: data.text != null || data.textBuilder != null || (data.showDecoration ?? false)
          ? data.decoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              )
          : null,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Progress indicator section
            if (data.showProgressIndicator ?? true)
              data.progressIndicatorBuilder?.call() ??
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Default circular progress indicator
                      CircularProgressIndicator(
                        color: data.progressColor ?? Colors.blue,
                      ),
                      // Timer-based close button
                      if (data.withTimer)
                        _TimedWidget(
                          duration: data.duration ?? const Duration(seconds: 2),
                          child: InkWell(
                            // Remove tap highlight effect
                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                            onTap: () {
                              HzLoading.hide();
                              data.onClosed?.call();
                            },
                            child: Icon(
                              data.closeIcon ?? Icons.close,
                              color: data.closeIconColor ?? Colors.blue,
                            ),
                          ),
                        ),
                    ],
                  ),

            // Text section
            if (data.text != null)
              data.textBuilder?.call(data.text!) ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        data.text!,
                        textAlign: TextAlign.center,
                        style: data.textStyle ??
                            const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                      ),
                    ],
                  ),

            // Progress percentage section
            if (data.progress != null)
              ValueListenableBuilder<int>(
                valueListenable: data.progress!,
                builder: (context, progressValue, child) {
                  return data.progressBuilder?.call(progressValue) ??
                      (data.useLinearProgress ?? false
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 200,
                                  child: LinearProgressIndicator(
                                    value: progressValue / 100,
                                    color: data.progressColor ?? Colors.blue,
                                    backgroundColor: Colors.grey.withAlpha(100),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${progressValue.toStringAsFixed(0)}%',
                                  style: data.progressTextStyle ??
                                      const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                ),
                              ],
                            )
                          : Text(
                              '(${progressValue.toStringAsFixed(0)}%)',
                              style: data.progressTextStyle ??
                                  const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                            ));
                },
              ),
          ],
        ),
      ),
    );

    // Apply size constraints if specified
    final maxWidth = data.maxWidth ?? HzLoadingConfig.instance.maxWidth;
    final maxHeight = data.maxHeight ?? HzLoadingConfig.instance.maxHeight;
    if (maxWidth != null || maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: content,
      );
    }

    // Apply margin if specified
    final margin = data.margin ?? HzLoadingConfig.instance.margin;
    if (margin != null) {
      content = Padding(
        padding: margin,
        child: content,
      );
    }

    // Apply alignment and positioning
    return Align(
      alignment: alignment,
      child: content,
    );
  }
}

/// Internal widget that displays a child after a specified duration.
///
/// This widget is used to implement the timer-based close button functionality.
/// The close button appears only after the specified duration has elapsed,
/// preventing accidental dismissals while still allowing user control.
///
/// ## Internal Use Only
///
/// This widget is used internally by [HzLoadingWidget] and should not be
/// used directly in application code.
///
/// ## Behavior
///
/// - Initially shows nothing ([SizedBox.shrink])
/// - After [duration] elapses, shows the [child] widget
/// - Automatically handles timer cleanup when disposed
/// - Respects widget lifecycle (checks [mounted] before state updates)
///
/// ## Use Case
///
/// This is primarily used for the close button that appears after a delay,
/// giving users time to see the loading screen before providing the option
/// to dismiss it manually.
class _TimedWidget extends StatefulWidget {
  /// The duration to wait before showing the child widget.
  final Duration duration;

  /// The widget to show after the duration has elapsed.
  final Widget child;

  /// Creates a new [_TimedWidget].
  ///
  /// ## Parameters
  ///
  /// - [duration]: How long to wait before showing the child
  /// - [child]: The widget to display after the timer expires
  const _TimedWidget({required this.duration, required this.child});

  @override
  State<_TimedWidget> createState() => _TimedWidgetState();
}

/// State class for [_TimedWidget] that manages the timer and visibility.
class _TimedWidgetState extends State<_TimedWidget> {
  /// Timer instance for tracking the delay.
  late Timer _timer;

  /// Whether to show the child widget.
  bool showChild = false;

  @override
  void initState() {
    super.initState();
    // Start timer that will show the child after the specified duration
    _timer = Timer(widget.duration, () {
      // Only update state if the widget is still mounted
      if (mounted) setState(() => showChild = true);
    });
  }

  @override
  void dispose() {
    // Clean up timer to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show child if timer has elapsed, otherwise show nothing
    return showChild ? widget.child : const SizedBox.shrink();
  }
}
