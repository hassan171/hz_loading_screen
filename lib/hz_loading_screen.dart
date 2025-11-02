/// Hz Loading Screen Package
///
/// A customizable and easy-to-use Flutter package for displaying overlay
/// loading screens that can be accessed from anywhere in your app.
///
/// This library provides:
/// - [HzLoadingScreen]: Main controller for showing/hiding loading screens
/// - [HzLoadingInitializer]: Widget to initialize the loading system
/// - [HzLoadingData]: Configuration class for customizing appearance
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
/// HzLoadingScreen.show(HzLoadingData(text: 'Loading...'));
/// ```
///
/// 3. Hide loading screen:
/// ```dart
/// HzLoadingScreen.hide();
/// ```
library;

export 'src/hz_loading_screen.dart';
export 'src/hz_loading_initializer.dart';
export 'src/hz_loading_data.dart';
