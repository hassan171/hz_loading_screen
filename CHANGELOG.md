# Changelog

All notable changes to the Hz Loading Screen package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-11-02

### 🚀 Added

#### Core Features

- **Global Loading Screen System**: Singleton-based loading screen accessible from anywhere in the app
- **EasyLoading-style Configuration**: `HzLoading.instance` API for global default settings
- **Overlay Architecture**: Custom overlay system for proper z-index management above all content
- **Complete Customization**: Full control over appearance, colors, text, animations, and positioning

#### 🎨 Visual Features

- **8 Animation Types**: Fade, scale, slide (4 directions), rotation, and none for entrance/exit transitions
- **Flexible Positioning**: Center, top, bottom, or custom positioning with precise alignment control
- **Blur & Backdrop Effects**: Background blur and color filter effects for enhanced visual impact
- **Layout Controls**: Margin, maximum width/height constraints for responsive design
- **Advanced Styling**: Custom decorations, padding, text styles, and progress colors

#### 📊 Progress System

- **Dual Progress Modes**: Support for both circular and linear progress indicators via `useLinearProgress`
- **Real-time Updates**: Live progress tracking with `ValueListenable<int>` from 0-100%
- **Custom Progress Builders**: Complete flexibility for creating custom progress displays
- **Progress Text Styling**: Separate styling options for progress percentage text

#### ⚡ Auto-dismiss Features

- **Smart Auto-hide**: Automatic hiding when progress reaches 100% with `autoHideOnComplete`
- **Configurable Delay**: Optional delay before auto-hiding with `autoHideDelay`
- **Safety Timeouts**: Maximum duration enforcement with `maxDuration` to prevent infinite loading
- **Event Callbacks**: `onAutoHide` callback for handling automatic dismissal events

#### 🛠️ Developer Experience

- **Comprehensive Example App**: Interactive showcase with 30+ controls for testing all features
- **35+ Unit Tests**: Complete test coverage for all functionality and edge cases
- **Type Safety**: Full Dart null safety with proper nullable types throughout
- **Extensive Documentation**: Detailed inline docs, usage examples, and best practices

#### Loading Screen Components

- **HzLoading**: Main controller class with static show/hide methods and instance configuration
- **HzLoadingInitializer**: Wrapper widget that sets up overlay infrastructure
- **HzLoadingData**: Configuration class with 32 customizable properties
- **HzLoadingConfig**: Global configuration singleton with EasyLoading-style API
- **HzLoadingWidget**: Internal stateful widget handling auto-dismiss logic and rendering

#### Interactive Features

- **Timer-based Close Button**: Configurable close button appearing after specified duration
- **Manual Dismissal**: User can dismiss loading screens with customizable close button
- **Keyboard Management**: Automatically manages keyboard visibility during loading
- **Callback Support**: Multiple callback options for closed and auto-hide events

#### Animation System

- **HzLoadingAnimation Enum**: 8 predefined animation types with default durations and curves
- **Custom Animation Control**: Configurable duration, curves, and separate entrance/exit animations
- **Smooth Transitions**: Built on `AnimatedSwitcher` for smooth, performant animations
- **Animation Presets**: Easy-to-use animation combinations for different use cases

#### Position & Layout System

- **HzLoadingPosition Enum**: Four positioning options (center, top, bottom, custom)
- **Custom Alignment**: Precise positioning with `Alignment` for custom positions
- **Responsive Constraints**: Maximum width/height limits for different screen sizes
- **Margin Support**: Configurable spacing around loading content
- **Layout Flexibility**: Support for different screen orientations and sizes

#### Blur & Backdrop Effects

- **Background Blur**: Configurable backdrop blur with sigma intensity control (1.0-20.0)
- **Color Filters**: Custom color filter effects for background content
- **Multiple Filter Types**: Darken, lighten, color overlay, and custom filter support
- **Performance Optimized**: Efficient rendering with conditional effect application

#### Configuration Options

**Core Properties:**
- `isVisible`: Control loading screen visibility state
- `withTimer`: Enable/disable timer-based close button functionality  
- `duration`: Configurable delay before close button appears
- `onClosed`: Callback for user-initiated dismissal events
- `text`: Display text with full styling support
- `textBuilder`: Custom widget builder for complex text layouts

**Progress Properties:**
- `progress`: Progress tracking with `ValueListenable<int>` (0-100)
- `useLinearProgress`: Switch between circular and linear progress indicators
- `progressBuilder`: Custom progress display widgets
- `progressIndicatorBuilder`: Custom progress indicator widgets (supports flutter_spinkit)
- `progressColor`: Progress indicator color customization
- `progressTextStyle`: Progress text styling options

**Visual Properties:**
- `materialColor`: Background overlay color with transparency support
- `padding`: Container padding configuration
- `decoration`: Full `BoxDecoration` styling support
- `showDecoration`: Control decoration visibility independent of text
- `textStyle`: Main text styling options
- `showProgressIndicator`: Toggle progress indicator visibility

**Animation Properties:**
- `entranceAnimation`: Entry animation type selection
- `exitAnimation`: Exit animation type selection  
- `animationDuration`: Custom animation timing
- `animationCurve`: Animation easing curves

**Backdrop Properties:**
- `enableBackdropBlur`: Toggle background blur effect
- `backdropBlurSigma`: Blur intensity control (1.0-20.0)
- `enableBackdropFilter`: Toggle color filter effects
- `backdropColorFilter`: Custom color filter configuration

**Position Properties:**
- `position`: Screen positioning (center, top, bottom, custom)
- `customAlignment`: Precise alignment for custom positioning
- `margin`: Spacing around loading content
- `maxWidth`: Maximum width constraint
- `maxHeight`: Maximum height constraint

**Auto-dismiss Properties:**
- `autoHideOnComplete`: Auto-hide when progress reaches 100%
- `autoHideDelay`: Delay before hiding after completion
- `onAutoHide`: Callback for automatic dismissal events
- `maxDuration`: Safety timeout for maximum loading duration

**Interactive Properties:**
- `closeIcon`: Custom close button icon
- `closeIconColor`: Close button color customization

### 🏗️ Technical Details

#### Architecture

- **Singleton Pattern**: Global access without context requirements using `HzLoading.instance`
- **Overlay System**: Custom overlay implementation for proper layering above all content
- **State Management**: Reactive updates with `ValueNotifier` and `ValueListenableBuilder`
- **Widget Lifecycle**: Proper cleanup patterns and automatic timer disposal
- **Memory Management**: Automatic resource cleanup and disposal patterns

#### Performance

- **Efficient Rendering**: `SizedBox.shrink()` when invisible for minimal overhead
- **Conditional Effects**: Backdrop effects only applied when enabled
- **Optimized Animations**: Hardware-accelerated animations with `AnimatedSwitcher`
- **Memory Efficient**: Automatic timer cleanup and proper widget disposal
- **Minimal Dependencies**: Lightweight with only Flutter framework dependencies

#### Dependencies

- **Flutter**: `>=1.17.0` for modern widget support and null safety
- **Dart SDK**: `>=3.5.4 <4.0.0` for latest language features and null safety

### 📱 Example Usage

#### Basic Setup
```dart
MaterialApp(
  builder: (context, child) => HzLoadingInitializer(child: child!),
)
```

#### Global Configuration
```dart
HzLoading.instance
  ..materialColor = Colors.black.withAlpha(120)
  ..progressColor = Colors.blue
  ..defaultText = 'Please wait...'
  ..entranceAnimation = HzLoadingAnimation.scale
  ..autoHideOnComplete = false;
```

#### Simple Loading
```dart
HzLoading.show(HzLoadingData(text: 'Loading...'));
await operation();
HzLoading.hide();
```

#### Auto-dismiss with Progress
```dart
ValueNotifier<int> progress = ValueNotifier<int>(0);
HzLoading.show(HzLoadingData(
  text: 'Processing...',
  progress: progress,
  autoHideOnComplete: true,
  autoHideDelay: Duration(milliseconds: 500),
));
// Will auto-hide when progress reaches 100%
```

#### Advanced Styling
```dart
HzLoading.show(HzLoadingData(
  text: 'Stylized Loading',
  entranceAnimation: HzLoadingAnimation.scale,
  position: HzLoadingPosition.top,
  enableBackdropBlur: true,
  margin: EdgeInsets.all(20),
));
```

#### Custom Progress with flutter_spinkit
```dart
// Add flutter_spinkit: ^5.2.2 to pubspec.yaml
import 'package:flutter_spinkit/flutter_spinkit.dart';

HzLoading.show(HzLoadingData(
  text: 'Beautiful Loading...',
  progressIndicatorBuilder: () => SpinKitWave(
    color: Colors.blue,
    size: 50.0,
  ),
));
```

### 🧪 Testing

- **35 Comprehensive Tests**: Full test coverage including unit and widget tests
- **Parameter Validation**: Tests for all configuration parameters and edge cases
- **Animation Testing**: Verification of all animation types and transitions
- **Auto-dismiss Testing**: Complete coverage of auto-hide functionality
- **Configuration Testing**: Tests for global configuration and defaults
- **Error Handling**: Tests for proper error handling and edge cases

### 📚 Documentation

- **Comprehensive README**: Detailed usage guide with examples and best practices
- **API Documentation**: Complete inline documentation for all public APIs
- **Interactive Example**: Live demo app with controls for all features
- **Best Practices Guide**: Recommended patterns and common pitfalls
- **Migration Guide**: Clear instructions for upgrading and configuration
