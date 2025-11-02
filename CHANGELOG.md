# Changelog

All notable changes to the Hz Loading Screen package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-11-02

### Added

#### Core Features

- **Global Loading Screen System**: Singleton-based loading screen that can be accessed from anywhere in the app
- **Overlay Architecture**: Custom overlay system that displays loading screens above all content
- **Complete Customization**: Full control over appearance, colors, text, and animations

#### Loading Screen Components

- **HzLoading**: Main controller class with static methods for show/hide operations
- **HzLoadingInitializer**: Wrapper widget that sets up the overlay infrastructure
- **HzLoadingData**: Configuration class with 18+ customizable properties
- **HzLoadingWidget**: Internal widget that renders the loading UI

#### Visual Features

- **Progress Indicators**: Support for circular progress indicators with custom colors and styling
- **Progress Tracking**: Built-in support for progress notifications with percentage display
- **Custom Builders**: Extensible system for custom progress indicators, text layouts, and progress displays
- **Material Design**: Follows Material Design principles with customizable Material backgrounds

#### Interactive Features

- **Timer-based Close Button**: Automatic close button that appears after configurable duration
- **Manual Dismissal**: User can dismiss loading screens with close button
- **Callback Support**: `onClosed` callback for handling user-initiated dismissals
- **Keyboard Management**: Automatically dismisses keyboard when loading screen appears

#### Styling & Layout

- **Custom Decorations**: Full `BoxDecoration` support for container styling
- **Flexible Padding**: Configurable padding around loading content
- **Text Styling**: Custom `TextStyle` support for both main text and progress text
- **Background Colors**: Customizable overlay background colors with transparency
- **Responsive Design**: Works across different screen sizes and orientations

#### Progress System

- **Linear Progress Support**: Custom progress builders for linear progress bars
- **Real-time Updates**: Live progress updates via `ValueListenable<int>`
- **Percentage Display**: Built-in percentage text with custom styling options
- **Custom Progress Widgets**: Full flexibility to create custom progress displays

#### Developer Experience

- **Comprehensive Documentation**: Detailed inline documentation for all public APIs
- **Type Safety**: Full Dart type safety with proper nullable types
- **Example App**: Complete example app demonstrating all features
- **Best Practices**: Documented patterns for proper usage and cleanup

#### Configuration Options

- `isVisible`: Control loading screen visibility
- `withTimer`: Enable/disable timer-based close button
- `duration`: Configurable delay before close button appears
- `onClosed`: Callback for user dismissal events
- `text`: Display text with optional custom builders
- `textBuilder`: Custom widget builder for text display
- `progress`: Progress tracking with `ValueListenable<int>`
- `materialColor`: Background overlay color customization
- `padding`: Container padding configuration
- `decoration`: Full `BoxDecoration` styling support
- `progressIndicatorBuilder`: Custom progress indicator widgets
- `progressColor`: Progress indicator color customization
- `closeIcon`: Custom close button icon
- `closeIconColor`: Close button color customization
- `progressBuilder`: Custom progress display widgets
- `textStyle`: Main text styling
- `progressTextStyle`: Progress text styling
- `showProgressIndicator`: Toggle progress indicator visibility

### Technical Details

#### Dependencies

- **Flutter**: `>=1.17.0` - Minimum Flutter version for compatibility
- **Dart SDK**: `>=3.5.4 <4.0.0` - Modern Dart features with null safety

#### Architecture

- **Singleton Pattern**: Global access without context requirements
- **Overlay System**: Custom overlay for proper z-index management
- **State Management**: `ValueNotifier` for reactive state updates
- **Widget Lifecycle**: Proper cleanup and disposal patterns

#### Performance

- **Efficient Rendering**: `SizedBox.shrink()` when not visible for minimal overhead
- **Memory Management**: Automatic timer cleanup and proper disposal patterns
- **Minimal Dependencies**: Lightweight package with only Flutter framework dependencies

### Example Usage

```dart
// Basic setup
MaterialApp(
  builder: (context, child) => HzLoadingInitializer(child: child!),
)

// Simple loading
HzLoading.show(HzLoadingData(text: 'Loading...'));
await operation();
HzLoading.hide();

// Progress tracking
ValueNotifier<int> progress = ValueNotifier<int>(0);
HzLoading.show(HzLoadingData(
  text: 'Processing...',
  progress: progress,
));
```
