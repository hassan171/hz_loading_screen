/// Hz Loading Screen Package
///
/// A customizable and easy-to-use Flutter package for displaying overlay
/// loading screens that can be accessed from anywhere in your app.
///
/// This library provides:
/// - [HzLoading]: Main controller for showing/hiding loading screens
/// - [HzLoadingInitializer]: Widget to initialize the loading system
/// - [HzLoadingData]: Configuration class for customizing appearance
/// - [HzLoadingConfig]: Global configuration for setting default values
///
/// ## Basic Usage
///
/// 1. Wrap your app with [HzLoadingInitializer]:
/// ```dart
/// MaterialApp(
///   builder: (context, child) => HzLoadingInitializer(child: child!),
///   // ... other properties
/// )
/// ```
///
/// 2. Show loading screen:
/// ```dart
/// HzLoading.show(HzLoadingData(text: 'Loading...'));
/// ```
///
/// 3. Hide loading screen:
/// ```dart
/// HzLoading.hide();
/// ```
///
/// ## Global Configuration
///
/// Set default values that apply to all loading screens:
/// ```dart
/// void main() {
///   // Configure defaults
///   HzLoading.instance
///     ..displayDuration = Duration(seconds: 3)
///     ..materialColor = Colors.black.withAlpha(100)
///     ..progressColor = Colors.blue
///     ..defaultText = 'Please wait...';
///
///   runApp(MyApp());
/// }
/// ```
///
/// Then use simplified calls:
/// ```dart
/// HzLoading.show(); // Uses configured defaults
/// // or override specific values:
/// HzLoading.show(HzLoadingData.withDefaults(
///   text: 'Custom message',
/// ));
/// ```
library;

export 'src/hz_loading_screen.dart';
export 'src/hz_loading_initializer.dart';
export 'src/hz_loading_data.dart';
export 'src/hz_loading_config.dart';
export 'src/hz_loading_animation.dart';
export 'src/hz_loading_position.dart';
