import 'package:flutter/material.dart';
import 'package:hz_loading_screen/src/hz_loading_widget.dart';

/// Initializer widget that sets up the loading screen overlay system.
///
/// This widget creates the necessary overlay infrastructure to display loading
/// screens on top of your app content. It must be used to wrap your app for
/// the [HzLoading] to function properly.
///
/// ## Required Setup
///
/// Place this widget in your app's builder function:
///
/// ```dart
/// MaterialApp(
///   title: 'My App',
///   home: MyHomePage(),
///   builder: (context, child) {
///     return HzLoadingInitializer(child: child!);
///   },
/// )
/// ```
///
/// ## How It Works
///
/// The [HzLoadingInitializer] creates a custom [Overlay] with two entries:
/// 1. Your app content (provided via the [child] parameter)
/// 2. The loading screen overlay ([HzLoadingWidget])
///
/// This approach ensures that loading screens appear above all other content,
/// including navigation drawers, dialogs, and other overlays, while maintaining
/// proper Material Design behavior.
///
/// ## Integration Examples
///
/// ### With MaterialApp:
/// ```dart
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: 'My App',
///       theme: ThemeData.light(),
///       home: HomePage(),
///       builder: (context, child) {
///         return HzLoadingInitializer(child: child!);
///       },
///     );
///   }
/// }
/// ```
///
/// ### With CupertinoApp:
/// ```dart
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CupertinoApp(
///       title: 'My App',
///       home: HomePage(),
///       builder: (context, child) {
///         return HzLoadingInitializer(child: child!);
///       },
///     );
///   }
/// }
/// ```
///
/// ### With additional wrappers:
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return HzLoadingInitializer(
///       child: SomeOtherWrapper(
///         child: child!,
///       ),
///     );
///   },
/// )
/// ```
///
/// ## Important Notes
///
/// - This widget should be placed as high as possible in your widget tree
/// - Only one [HzLoadingInitializer] is needed per app
/// - The [child] parameter must not be null
/// - Loading screens will appear above all content wrapped by this widget
class HzLoadingInitializer extends StatefulWidget {
  /// The main app widget to be wrapped with loading screen functionality.
  ///
  /// This is typically the widget returned by your app's builder function,
  /// which usually contains your app's main content, navigation, and other
  /// UI elements.
  ///
  /// The child will be displayed normally when no loading screen is active,
  /// and will be overlaid by the loading screen when [HzLoading.show]
  /// is called.
  final Widget child;

  /// Creates a new [HzLoadingInitializer] instance.
  ///
  /// ## Parameters
  ///
  /// - [child]: Required. The main app widget to wrap with loading functionality.
  ///   This is typically the widget passed to your app's builder function.
  ///
  /// ## Example
  ///
  /// ```dart
  /// HzLoadingInitializer(
  ///   child: MyAppContent(),
  /// )
  /// ```
  const HzLoadingInitializer({
    super.key,
    required this.child,
  });

  @override
  State<HzLoadingInitializer> createState() => _HzLoadingInitializerState();
}

/// Private state class for [HzLoadingInitializer].
///
/// This class manages the overlay structure that enables loading screens
/// to appear on top of all app content.
class _HzLoadingInitializerState extends State<HzLoadingInitializer> {
  @override
  Widget build(BuildContext context) {
    // Create our own overlay that contains both the child and loading system
    return Overlay(
      initialEntries: [
        // Main app content - this is the bottom layer
        OverlayEntry(
          builder: (context) => widget.child,
        ),
        // Loading screen overlay - this appears on top of everything
        OverlayEntry(
          builder: (context) => const HzLoadingWidget(),
        ),
      ],
    );
  }
}
