import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_loading_screen/hz_loading_screen.dart';

/// Internal widget that renders the loading screen overlay.
///
/// This widget is responsible for displaying the actual loading screen UI
/// based on the configuration provided through [HzLoadingData]. It listens
/// to changes in the loading state and updates the display accordingly.
///
/// ## Internal Use Only
///
/// This widget is used internally by [HzLoadingInitializer] and should not
/// be used directly in your app code. Use [HzLoadingScreen.show] and
/// [HzLoadingScreen.hide] instead.
///
/// ## Features
///
/// - Responsive to [HzLoadingData] changes via [ValueListenableBuilder]
/// - Supports custom progress indicators, text builders, and styling
/// - Implements timer-based close button functionality
/// - Handles progress display with both default and custom builders
/// - Manages overlay visibility and animations
///
/// ## Architecture
///
/// The widget uses a [ValueListenableBuilder] to listen for changes in
/// [HzLoadingScreen.data] and rebuilds the UI accordingly. When the loading
/// screen is not visible, it returns [SizedBox.shrink] to minimize overhead.
class HzLoadingWidget extends StatelessWidget {
  /// Creates a new [HzLoadingWidget].
  ///
  /// This constructor is used internally and should not be called directly.
  const HzLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HzLoadingData>(
      valueListenable: HzLoadingScreen.data,
      builder: (context, value, child) {
        // If not visible, return empty widget for performance
        if (value.isVisible == false) return const SizedBox.shrink();

        return Material(
          // Semi-transparent background overlay
          color: value.materialColor ?? Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              padding: value.padding ?? const EdgeInsets.all(16),
              decoration: value.decoration ??
                  BoxDecoration(
                    // Show white background only when text is present
                    color: value.text == null ? Colors.transparent : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Progress indicator section
                    if (value.showProgressIndicator ?? true)
                      value.progressIndicatorBuilder?.call() ??
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Default circular progress indicator
                              CircularProgressIndicator(
                                color: value.progressColor ?? Colors.blue,
                              ),
                              // Timer-based close button
                              if (value.withTimer)
                                _TimedWidget(
                                  duration: value.duration ?? const Duration(seconds: 2),
                                  child: InkWell(
                                    // Remove tap highlight effect
                                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                                    onTap: () {
                                      HzLoadingScreen.hide();
                                      value.onClosed?.call();
                                    },
                                    child: Icon(
                                      value.closeIcon ?? Icons.close,
                                      color: value.closeIconColor ?? Colors.blue,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                    // Text section
                    if (value.text != null)
                      value.textBuilder?.call(value.text!) ??
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                value.text!,
                                textAlign: TextAlign.center,
                                style: value.textStyle ??
                                    const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                              ),
                            ],
                          ),

                    // Progress percentage section
                    if (value.progress != null)
                      ValueListenableBuilder<int>(
                        valueListenable: value.progress!,
                        builder: (context, progressValue, child) {
                          return value.progressBuilder?.call(progressValue) ??
                              Text(
                                '(${progressValue.toStringAsFixed(0)}%)',
                                style: value.progressTextStyle ??
                                    const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                              );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
