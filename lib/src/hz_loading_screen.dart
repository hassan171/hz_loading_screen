import 'package:flutter/material.dart';
import 'package:hz_loading_screen/src/hz_loading_data.dart';
import 'package:hz_loading_screen/src/hz_loading_config.dart';

/// Main controller class for the Hz Loading Screen system.
///
/// This singleton class provides static methods to show and hide loading screens
/// from anywhere in your application without requiring a BuildContext.
///
/// ## Setup Required
///
/// Before using this class, make sure to wrap your app with [HzLoadingInitializer]:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return HzLoadingInitializer(child: child!);
///   },
///   // ... other properties
/// )
/// ```
///
/// ## Basic Usage
///
/// ### Simple loading screen:
/// ```dart
/// // Show loading
/// HzLoading.show(HzLoadingData(text: 'Loading...'));
///
/// // Perform async operation
/// await someAsyncOperation();
///
/// // Hide loading
/// HzLoading.hide();
/// ```
///
/// ### Loading with progress:
/// ```dart
/// ValueNotifier<int> progress = ValueNotifier<int>(0);
///
/// HzLoading.show(HzLoadingData(
///   text: 'Downloading...',
///   progress: progress,
/// ));
///
/// // Update progress
/// for (int i = 0; i <= 100; i += 10) {
///   await Future.delayed(Duration(milliseconds: 100));
///   progress.value = i;
/// }
///
/// HzLoading.hide();
/// progress.dispose();
/// ```
///
/// ## Best Practices
///
/// 1. Always call [hide] in both success and error cases
/// 2. Use try-finally blocks to ensure loading screens are dismissed
/// 3. Dispose progress notifiers when done
/// 4. Check [isVisible] before showing if needed
///
/// ```dart
/// void performOperation() async {
///   HzLoading.show(HzLoadingData(text: 'Processing...'));
///
///   try {
///     await riskyOperation();
///   } catch (e) {
///     // Handle error
///   } finally {
///     HzLoading.hide();
///   }
/// }
/// ```
class HzLoading {
  /// Private singleton instance.
  static final HzLoading _ = HzLoading._internal();

  /// Factory constructor that returns the singleton instance.
  factory HzLoading() => _;

  /// Private constructor for singleton pattern.
  HzLoading._internal();

  /// Internal data notifier that manages the loading screen state.
  ///
  /// This [ValueNotifier] is used internally by the [HzLoadingWidget] to listen
  /// for changes in loading screen configuration and visibility.
  ///
  /// External code should not interact with this directly. Use the static
  /// methods [show], [hide], and [isVisible] instead.
  static final ValueNotifier<HzLoadingData> data = ValueNotifier(HzLoadingData());

  /// Returns `true` if the loading screen is currently visible, `false` otherwise.
  ///
  /// This getter provides a convenient way to check the current visibility state
  /// without needing to access the internal data structure.
  ///
  /// ## Example
  ///
  /// ```dart
  /// if (!HzLoading.isVisible) {
  ///   HzLoading.show(HzLoadingData(text: 'Loading...'));
  /// }
  /// ```
  static bool get isVisible => data.value.isVisible;

  /// Access to the global configuration instance.
  ///
  /// This provides convenient access to [HzLoadingConfig.instance] for setting
  /// default values that will be applied to all loading screens.
  ///
  /// ## Example
  ///
  /// ```dart
  /// HzLoading.instance
  ///   ..displayDuration = Duration(seconds: 3)
  ///   ..materialColor = Colors.black.withAlpha(100)
  ///   ..progressColor = Colors.blue
  ///   ..defaultText = 'Please wait...';
  /// ```
  ///
  /// This is equivalent to:
  /// ```dart
  /// HzLoadingConfig.instance
  ///   ..displayDuration = Duration(seconds: 3)
  ///   ..materialColor = Colors.black.withAlpha(100)
  ///   ..progressColor = Colors.blue
  ///   ..defaultText = 'Please wait...';
  /// ```
  static HzLoadingConfig get instance => HzLoadingConfig.instance;

  /// Shows the loading screen with the specified configuration.
  ///
  /// This method displays an overlay loading screen that covers the entire app.
  /// The loading screen will remain visible until [hide] is called.
  ///
  /// ## Parameters
  ///
  /// - [loadingData]: Configuration for the loading screen appearance and behavior.
  ///   If `null`, a default loading screen will be shown.
  ///
  /// ## Behavior
  ///
  /// - Automatically unfocuses any currently focused widget (dismisses keyboard)
  /// - Updates the global loading state to make the screen visible
  /// - Can be called multiple times to update the loading screen configuration
  ///
  /// ## Example
  ///
  /// ### Basic usage:
  /// ```dart
  /// HzLoading.show();
  /// ```
  ///
  /// ### With custom text:
  /// ```dart
  /// HzLoading.show(HzLoadingData(
  ///   text: 'Please wait...',
  ///   withTimer: false,
  /// ));
  /// ```
  ///
  /// ### With custom styling:
  /// ```dart
  /// HzLoading.show(HzLoadingData(
  ///   text: 'Processing...',
  ///   materialColor: Colors.black.withAlpha(100),
  ///   decoration: BoxDecoration(
  ///     color: Colors.white,
  ///     borderRadius: BorderRadius.circular(12),
  ///   ),
  /// ));
  /// ```
  ///
  /// ### With progress tracking:
  /// ```dart
  /// ValueNotifier<int> progress = ValueNotifier<int>(0);
  /// HzLoading.show(HzLoadingData(
  ///   text: 'Downloading...',
  ///   progress: progress,
  /// ));
  /// ```
  static void show([HzLoadingData? loadingData]) {
    // Dismiss keyboard if visible
    FocusManager.instance.primaryFocus?.unfocus();

    // Update loading data - use provided data, create with defaults, or fallback to basic default
    data.value = loadingData?.copyWith(isVisible: true) ?? HzLoadingData.withDefaults(isVisible: true);
  }

  /// Hides the loading screen.
  ///
  /// This method immediately hides the loading screen overlay, allowing normal
  /// app interaction to resume. The loading screen will fade out smoothly.
  ///
  /// ## Usage
  ///
  /// Call this method when your async operation is complete, whether it succeeded
  /// or failed. It's recommended to use try-finally blocks to ensure the loading
  /// screen is always dismissed.
  ///
  /// ## Example
  ///
  /// ### Basic usage:
  /// ```dart
  /// HzLoading.show(HzLoadingData(text: 'Loading...'));
  /// await performAsyncOperation();
  /// HzLoading.hide();
  /// ```
  ///
  /// ### With error handling:
  /// ```dart
  /// HzLoading.show(HzLoadingData(text: 'Processing...'));
  ///
  /// try {
  ///   await riskyOperation();
  /// } catch (e) {
  ///   showErrorDialog(e.toString());
  /// } finally {
  ///   HzLoading.hide(); // Always hide loading
  /// }
  /// ```
  ///
  /// ## Notes
  ///
  /// - Safe to call multiple times
  /// - Safe to call even if loading screen is not visible
  /// - Will trigger any [onClosed] callback if the loading was dismissed by user interaction
  static void hide() {
    data.value = data.value.copyWith(isVisible: false);
  }
}
