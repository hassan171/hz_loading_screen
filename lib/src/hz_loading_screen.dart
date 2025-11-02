import 'package:flutter/material.dart';
import 'package:hz_loading_screen/src/hz_loading_data.dart';

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
/// HzLoadingScreen.show(HzLoadingData(text: 'Loading...'));
///
/// // Perform async operation
/// await someAsyncOperation();
///
/// // Hide loading
/// HzLoadingScreen.hide();
/// ```
///
/// ### Loading with progress:
/// ```dart
/// ValueNotifier<int> progress = ValueNotifier<int>(0);
///
/// HzLoadingScreen.show(HzLoadingData(
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
/// HzLoadingScreen.hide();
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
///   HzLoadingScreen.show(HzLoadingData(text: 'Processing...'));
///
///   try {
///     await riskyOperation();
///   } catch (e) {
///     // Handle error
///   } finally {
///     HzLoadingScreen.hide();
///   }
/// }
/// ```
class HzLoadingScreen {
  /// Private singleton instance.
  static final HzLoadingScreen _ = HzLoadingScreen._internal();

  /// Factory constructor that returns the singleton instance.
  factory HzLoadingScreen() => _;

  /// Private constructor for singleton pattern.
  HzLoadingScreen._internal();

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
  /// if (!HzLoadingScreen.isVisible) {
  ///   HzLoadingScreen.show(HzLoadingData(text: 'Loading...'));
  /// }
  /// ```
  static bool get isVisible => data.value.isVisible;

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
  /// HzLoadingScreen.show();
  /// ```
  ///
  /// ### With custom text:
  /// ```dart
  /// HzLoadingScreen.show(HzLoadingData(
  ///   text: 'Please wait...',
  ///   withTimer: false,
  /// ));
  /// ```
  ///
  /// ### With custom styling:
  /// ```dart
  /// HzLoadingScreen.show(HzLoadingData(
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
  /// HzLoadingScreen.show(HzLoadingData(
  ///   text: 'Downloading...',
  ///   progress: progress,
  /// ));
  /// ```
  static void show([HzLoadingData? loadingData]) {
    // Dismiss keyboard if visible
    FocusManager.instance.primaryFocus?.unfocus();

    // Update loading data - use provided data or create default visible loading
    data.value = loadingData ?? HzLoadingData(isVisible: true);
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
  /// HzLoadingScreen.show(HzLoadingData(text: 'Loading...'));
  /// await performAsyncOperation();
  /// HzLoadingScreen.hide();
  /// ```
  ///
  /// ### With error handling:
  /// ```dart
  /// HzLoadingScreen.show(HzLoadingData(text: 'Processing...'));
  ///
  /// try {
  ///   await riskyOperation();
  /// } catch (e) {
  ///   showErrorDialog(e.toString());
  /// } finally {
  ///   HzLoadingScreen.hide(); // Always hide loading
  /// }
  /// ```
  ///
  /// ## Notes
  ///
  /// - Safe to call multiple times
  /// - Safe to call even if loading screen is not visible
  /// - Will trigger any [onClosed] callback if the loading was dismissed by user interaction
  static void hide() {
    data.value = HzLoadingData(isVisible: false);
  }
}
