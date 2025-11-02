# Hz Loading Screen

A highly customizable and feature-rich Flutter package for displaying overlay loading screens with advanced capabilities like auto-dismiss, animations, blur effects, and flexible positioning. Access loading screens from anywhere in your app without context dependencies.

## ✨ Features

### Core Functionality
- **🌐 Global Access**: Show/hide loading screens from anywhere without context
- **⚙️ EasyLoading-style Configuration**: Instance-based global configuration system
- **📱 Overlay System**: Non-intrusive overlay that preserves navigation state
- **🎯 Auto-dismiss**: Smart auto-hide on progress completion or timeout

### Visual Customization
- **🎨 Highly Customizable**: Colors, text, decorations, blur effects, and positioning
- **✨ 8 Animation Types**: Fade, scale, slide, rotation animations for entrance/exit
- **📍 Flexible Positioning**: Center, top, bottom, or custom positioning with alignment
- **🌫️ Blur & Backdrop Effects**: Background blur and color filter effects
- **📏 Layout Controls**: Margin, max width/height constraints for responsive design

### Progress & Interaction
- **📊 Dual Progress Modes**: Circular and linear progress indicators
- **⏱️ Timer-based Close**: Auto-appearing close button after specified duration
- **🚀 Smart Auto-dismiss**: Automatic hiding on completion with optional delay
- **🔒 Safety Timeouts**: Maximum duration enforcement to prevent infinite loading
- **📞 Callback Support**: onClosed and onAutoHide event handlers

### Developer Experience
- **📖 Comprehensive Documentation**: Detailed API docs and examples
- **🧪 Fully Tested**: 35+ comprehensive tests covering all features
- **🎮 Interactive Showcase**: Complete demo app with live controls
- **💎 Material Design**: Built with Material Design principles

## Screenshots

| Simple Loading                    | Custom Loading                    | Progress Loading                      |
| --------------------------------- | --------------------------------- | ------------------------------------- |
| ![Simple](screenshots/simple.png) | ![Custom](screenshots/custom.png) | ![Progress](screenshots/progress.png) |

## Getting Started

### Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  hz_loading_screen: ^0.0.1
```

Then run:

```bash
flutter pub get
```

### Basic Setup

Wrap your app with `HzLoadingInitializer` in your main widget:

```dart
import 'package:flutter/material.dart';
import 'package:hz_loading_screen/hz_loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: const MyHomePage(),
      builder: (context, child) {
        return HzLoadingInitializer(child: child!);
      },
    );
  }
}
```

### Global Configuration (EasyLoading-style)

Set default values that will be applied to all loading screens, similar to EasyLoading's instance configuration:

```dart
import 'package:flutter/material.dart';
import 'package:hz_loading_screen/hz_loading_screen.dart';

void main() {
  // Configure global defaults (optional)
  HzLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..materialColor = Colors.black.withAlpha(120)
    ..progressColor = Colors.blue
    ..closeIconColor = Colors.blue
    ..defaultText = 'Please wait...'
    ..textStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    )
    ..showDecoration = true
    ..useLinearProgress = false
    ..entranceAnimation = HzLoadingAnimation.fade
    ..exitAnimation = HzLoadingAnimation.fade
    ..autoHideOnComplete = false
    ..position = HzLoadingPosition.center
    ..enableBackdropBlur = false
    ..decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

  runApp(const MyApp());
}
```

With global configuration, you can:

```dart
// Use all defaults
HzLoading.show();

// Use defaults with custom text
HzLoading.show(HzLoadingData.withDefaults(
  text: 'Custom message',
));

// Override specific defaults
HzLoading.show(HzLoadingData.withDefaults(
  text: 'Downloading...',
  progressColor: Colors.green, // Override just the color
  entranceAnimation: HzLoadingAnimation.scale,
));
```

## Usage

### Simple Loading Screen

```dart
// Show loading
HzLoading.show(HzLoadingData(
  text: 'Loading, please wait...',
  withTimer: false,
));

// Perform your async operation
await Future.delayed(const Duration(seconds: 3));

// Hide loading
HzLoading.hide();
```

### Auto-dismiss with Progress

```dart
ValueNotifier<int> progress = ValueNotifier<int>(0);

HzLoading.show(HzLoadingData(
  text: 'Processing...',
  progress: progress,
  autoHideOnComplete: true,
  autoHideDelay: const Duration(milliseconds: 500),
  onAutoHide: () => print('Auto-completed!'),
));

// Simulate progress - will auto-hide at 100%
for (int i = 0; i <= 100; i += 10) {
  await Future.delayed(const Duration(milliseconds: 200));
  progress.value = i;
}
// No need to call HzLoading.hide() - it auto-hides!

progress.dispose();
```

### Animated Loading with Positioning

```dart
HzLoading.show(HzLoadingData(
  text: 'Uploading...',
  entranceAnimation: HzLoadingAnimation.scale,
  exitAnimation: HzLoadingAnimation.fade,
  position: HzLoadingPosition.top,
  margin: const EdgeInsets.all(20),
  maxWidth: 300,
));
```

### Blur & Backdrop Effects

```dart
HzLoading.show(HzLoadingData(
  text: 'Processing...',
  enableBackdropBlur: true,
  backdropBlurSigma: 10.0,
  enableBackdropFilter: true,
  backdropColorFilter: ColorFilter.mode(
    Colors.blue.withOpacity(0.2),
    BlendMode.overlay,
  ),
));
```

### Custom Styled Loading

```dart
HzLoadingScreen.show(HzLoadingData(
  text: 'Processing...',
  materialColor: Colors.black.withAlpha(150),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  progressColor: Colors.blue,
  textStyle: const TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ),
));
```

### Loading with Linear Progress

```dart
ValueNotifier<int> progress = ValueNotifier<int>(0);

HzLoading.show(HzLoadingData(
  text: 'Downloading...',
  progress: progress,
  useLinearProgress: true, // Use linear instead of circular
  withTimer: false,
));

for (int i = 0; i <= 100; i += 10) {
  await Future.delayed(const Duration(milliseconds: 200));
  progress.value = i;
}

HzLoading.hide();
progress.dispose();
```

### Safety Timeout

```dart
HzLoading.show(HzLoadingData(
  text: 'Processing...',
  maxDuration: const Duration(minutes: 2), // Force hide after 2 minutes
  onAutoHide: () => print('Operation timed out'),
));
```

### Custom Progress Builder

```dart
ValueNotifier<int> progress = ValueNotifier<int>(0);

HzLoading.show(HzLoadingData(
  text: 'Processing files...',
  progress: progress,
  progressBuilder: (progressValue) {
    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: progressValue / 100,
            color: Colors.blue,
            backgroundColor: Colors.grey.withAlpha(100),
          ),
        ),
        const SizedBox(height: 10),
        Text('${progressValue}% completed'),
      ],
    );
  },
));
```

### Timer-based Close Button

```dart
HzLoading.show(HzLoadingData(
  text: 'Loading...',
  withTimer: true,
  duration: const Duration(seconds: 3), // Close button appears after 3 seconds
  onClosed: () {
    print('Loading was closed by user');
  },
));
```

## 🎮 Animation Types

The package includes 8 built-in animation types:

```dart
enum HzLoadingAnimation {
  fade,        // Simple opacity transition
  scale,       // Scales up from center
  slideUp,     // Slides in from bottom
  slideDown,   // Slides in from top
  slideLeft,   // Slides in from right
  slideRight,  // Slides in from left
  rotation,    // Rotates while fading
  none,        // No animation
}

// Usage
HzLoading.show(HzLoadingData(
  text: 'Animated Loading!',
  entranceAnimation: HzLoadingAnimation.scale,
  exitAnimation: HzLoadingAnimation.fade,
  animationDuration: const Duration(milliseconds: 400),
  animationCurve: Curves.easeOutBack,
));
```

## 📍 Positioning & Layout

Control exactly where and how your loading screen appears:

```dart
enum HzLoadingPosition {
  center,  // Center of screen (default)
  top,     // Top of screen
  bottom,  // Bottom of screen
  custom,  // Use customAlignment
}

// Positioning examples
HzLoading.show(HzLoadingData(
  text: 'Top positioned',
  position: HzLoadingPosition.top,
  margin: const EdgeInsets.all(20),
));

HzLoading.show(HzLoadingData(
  text: 'Custom positioned',
  position: HzLoadingPosition.custom,
  customAlignment: Alignment.topRight,
  maxWidth: 250,
  maxHeight: 150,
));
```

## API Reference

### HzLoading

The main class for controlling the loading screen.

#### Static Methods

- `show(HzLoadingData? loadingData)` - Show the loading screen
- `hide()` - Hide the loading screen
- `isVisible` - Get current visibility state

#### Static Properties

- `instance` - Access to global configuration (HzLoadingConfig.instance)

### HzLoadingData

Configuration class for customizing the loading screen appearance and behavior.

#### Core Properties

| Property                   | Type                       | Description                           | Default                       |
| -------------------------- | -------------------------- | ------------------------------------- | ----------------------------- |
| `isVisible`                | `bool`                     | Whether the loading screen is visible | `true`                        |
| `withTimer`                | `bool`                     | Show close button after duration      | `true`                        |
| `duration`                 | `Duration?`                | Time before close button appears      | `Duration(seconds: 2)`        |
| `onClosed`                 | `Function?`                | Callback when loading is closed       | `null`                        |
| `text`                     | `String?`                  | Loading text to display               | `null`                        |
| `textBuilder`              | `Widget Function(String)?` | Custom text widget builder            | `null`                        |
| `progress`                 | `ValueListenable<int>?`    | Progress value notifier (0-100)       | `null`                        |

#### Visual Styling

| Property                   | Type                    | Description                           | Default                       |
| -------------------------- | ----------------------- | ------------------------------------- | ----------------------------- |
| `materialColor`            | `Color?`                | Background overlay color              | `Colors.black.withAlpha(150)` |
| `padding`                  | `EdgeInsetsGeometry?`   | Container padding                     | `EdgeInsets.all(16)`          |
| `decoration`               | `BoxDecoration?`        | Container decoration                  | Auto-generated                |
| `progressColor`            | `Color?`                | Progress indicator color              | `Colors.blue`                 |
| `closeIcon`                | `IconData?`             | Close button icon                     | `Icons.close`                 |
| `closeIconColor`           | `Color?`                | Close button color                    | `Colors.blue`                 |
| `textStyle`                | `TextStyle?`            | Text styling                          | Default style                 |
| `progressTextStyle`        | `TextStyle?`            | Progress text styling                 | Default style                 |
| `showProgressIndicator`    | `bool?`                 | Show/hide progress indicator          | `true`                        |
| `showDecoration`           | `bool?`                 | Show decoration without text          | `false`                       |
| `useLinearProgress`        | `bool?`                 | Use linear instead of circular        | `false`                       |

#### Animation Properties

| Property                   | Type                    | Description                           | Default                       |
| -------------------------- | ----------------------- | ------------------------------------- | ----------------------------- |
| `entranceAnimation`        | `HzLoadingAnimation?`   | Entry animation type                  | `HzLoadingAnimation.fade`     |
| `exitAnimation`            | `HzLoadingAnimation?`   | Exit animation type                   | Same as entrance              |
| `animationDuration`        | `Duration?`             | Animation duration                    | `250ms`                       |
| `animationCurve`           | `Curve?`                | Animation easing curve                | `Curves.easeInOut`            |

#### Backdrop Effects

| Property                   | Type                    | Description                           | Default                       |
| -------------------------- | ----------------------- | ------------------------------------- | ----------------------------- |
| `enableBackdropBlur`       | `bool?`                 | Apply background blur                 | `false`                       |
| `backdropBlurSigma`        | `double?`               | Blur intensity (1.0-20.0)            | `5.0`                         |
| `enableBackdropFilter`     | `bool?`                 | Apply color filter to background      | `false`                       |
| `backdropColorFilter`      | `ColorFilter?`          | Color filter for background           | `null`                        |

#### Position & Layout

| Property                   | Type                    | Description                           | Default                       |
| -------------------------- | ----------------------- | ------------------------------------- | ----------------------------- |
| `position`                 | `HzLoadingPosition?`    | Screen position                       | `HzLoadingPosition.center`    |
| `customAlignment`          | `Alignment?`            | Custom alignment (when position=custom)| `Alignment.center`           |
| `margin`                   | `EdgeInsets?`           | Margin around content                 | `null`                        |
| `maxWidth`                 | `double?`               | Maximum width constraint              | `null`                        |
| `maxHeight`                | `double?`               | Maximum height constraint             | `null`                        |

#### Auto-dismiss Features

| Property                   | Type                    | Description                           | Default                       |
| -------------------------- | ----------------------- | ------------------------------------- | ----------------------------- |
| `autoHideOnComplete`       | `bool?`                 | Auto-hide when progress reaches 100%  | `false`                       |
| `autoHideDelay`            | `Duration?`             | Delay before hiding after completion  | `null`                        |
| `onAutoHide`               | `Function?`             | Callback when auto-hidden             | `null`                        |
| `maxDuration`              | `Duration?`             | Force hide after timeout              | `null`                        |

#### Custom Builders

| Property                   | Type                       | Description                           | Default                       |
| -------------------------- | -------------------------- | ------------------------------------- | ----------------------------- |
| `progressIndicatorBuilder` | `Widget Function()?`       | Custom progress indicator (supports flutter_spinkit) | `CircularProgressIndicator`   |
| `progressBuilder`          | `Widget Function(int)?`    | Custom progress display               | Default percentage text       |

#### Factory Methods

- `HzLoadingData()` - Create with specified values
- `HzLoadingData.withDefaults()` - Create using global configuration defaults

### HzLoadingConfig

Global configuration class for setting default values that apply to all loading screens.

#### Static Properties

- `instance` - Get the singleton configuration instance

#### All Configuration Properties

The configuration class supports all the same properties as `HzLoadingData`, allowing you to set global defaults for:

- **Core properties**: `displayDuration`, `defaultText`, `withTimer`, `onClosed`
- **Visual styling**: `materialColor`, `padding`, `decoration`, `progressColor`, `textStyle`, etc.
- **Animation settings**: `entranceAnimation`, `exitAnimation`, `animationDuration`, `animationCurve`
- **Backdrop effects**: `enableBackdropBlur`, `backdropBlurSigma`, `enableBackdropFilter`, `backdropColorFilter`
- **Position & layout**: `position`, `customAlignment`, `margin`, `maxWidth`, `maxHeight`
- **Auto-dismiss**: `autoHideOnComplete`, `autoHideDelay`, `onAutoHide`, `maxDuration`
- **Custom builders**: `progressIndicatorBuilder`, `textBuilder`, `progressBuilder`

#### Configuration Methods

- `reset()` - Reset all configuration values to null
- `copy()` - Create a copy of the current configuration

### HzLoadingAnimation

Enum defining available animation types:

```dart
enum HzLoadingAnimation {
  fade,        // Simple opacity transition
  scale,       // Scales up from center
  slideUp,     // Slides in from bottom
  slideDown,   // Slides in from top
  slideLeft,   // Slides in from right
  slideRight,  // Slides in from left
  rotation,    // Rotates while fading
  none,        // No animation
}
```

### HzLoadingPosition

Enum defining positioning options:

```dart
enum HzLoadingPosition {
  center,  // Center of screen (default)
  top,     // Top of screen
  bottom,  // Bottom of screen
  custom,  // Use customAlignment property
}
```

### HzLoadingInitializer

Widget that initializes the loading system. Must wrap your app.

#### Properties

| Property | Type     | Description     |
| -------- | -------- | --------------- |
| `child`  | `Widget` | Your app widget |

## Examples

The package includes a comprehensive interactive example app demonstrating all features:

- **Interactive Controls**: Live configuration with switches, dropdowns, and sliders
- **All Animation Types**: Test all 8 entrance/exit animations
- **Position Testing**: Try all positioning options with custom alignments
- **Blur Effects**: Experiment with backdrop blur and color filters
- **Auto-dismiss Demos**: See auto-hide functionality with progress tracking
- **Progress Variations**: Both circular and linear progress indicators
- **Custom Builders**: Examples of custom text and progress builders

### Key Demo Features

- **Real-time Configuration**: Floating action button to test current settings
- **Comprehensive Controls**: Over 30 interactive controls for all parameters
- **Live Preview**: See changes immediately with the floating test button
- **Configuration Display**: Current settings shown in an organized card

To run the example:

```bash
cd example
flutter run
```

## Advanced Usage

### Auto-dismiss Patterns

#### Progress-based Auto-dismiss

```dart
Future<void> downloadFile() async {
  ValueNotifier<int> progress = ValueNotifier<int>(0);
  
  HzLoading.show(HzLoadingData(
    text: 'Downloading file...',
    progress: progress,
    autoHideOnComplete: true,
    autoHideDelay: const Duration(milliseconds: 800), // Brief success display
    onAutoHide: () {
      // File download completed
      Navigator.pushNamed(context, '/download-complete');
    },
  ));

  try {
    await downloadWithProgress(progress);
    // Loading will auto-hide when progress reaches 100%
  } catch (e) {
    HzLoading.hide();
    showErrorDialog(e);
  } finally {
    progress.dispose();
  }
}
```

#### Safety Timeout Pattern

```dart
Future<void> performLongOperation() async {
  HzLoading.show(HzLoadingData(
    text: 'Processing...',
    maxDuration: const Duration(minutes: 5), // Safety timeout
    onAutoHide: () {
      print('Operation timed out after 5 minutes');
      showTimeoutDialog();
    },
  ));

  try {
    await longRunningOperation();
    HzLoading.hide(); // Normal completion
  } catch (e) {
    HzLoading.hide();
    handleError(e);
  }
}
```

### Global Configuration Management

#### Complete Configuration Setup

```dart
void configureLoadingDefaults() {
  HzLoading.instance
    ..displayDuration = const Duration(seconds: 4)
    ..materialColor = Colors.black.withAlpha(150)
    ..progressColor = Colors.blue
    ..closeIconColor = Colors.blue
    ..defaultText = 'Please wait...'
    ..textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    )
    ..showDecoration = true
    ..useLinearProgress = false
    ..entranceAnimation = HzLoadingAnimation.scale
    ..exitAnimation = HzLoadingAnimation.fade
    ..animationDuration = const Duration(milliseconds: 300)
    ..position = HzLoadingPosition.center
    ..autoHideOnComplete = false
    ..enableBackdropBlur = false
    ..decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
}
```

#### Theme-based Configuration

```dart
void configureForDarkTheme() {
  HzLoading.instance
    ..materialColor = Colors.black.withAlpha(200)
    ..decoration = BoxDecoration(
      color: Colors.grey[800],
      borderRadius: BorderRadius.circular(12),
    )
    ..textStyle = const TextStyle(
      fontSize: 16,
      color: Colors.white,
    )
    ..progressColor = Colors.white
    ..closeIconColor = Colors.white;
}

void configureForLightTheme() {
  HzLoading.instance
    ..materialColor = Colors.black.withAlpha(100)
    ..decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    )
    ..textStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black87,
    )
    ..progressColor = Colors.blue
    ..closeIconColor = Colors.blue;
}
```

#### Animation Presets

```dart
void setupQuickAnimations() {
  HzLoading.instance
    ..entranceAnimation = HzLoadingAnimation.scale
    ..exitAnimation = HzLoadingAnimation.fade
    ..animationDuration = const Duration(milliseconds: 200)
    ..animationCurve = Curves.easeOutCubic;
}

void setupDramaticAnimations() {
  HzLoading.instance
    ..entranceAnimation = HzLoadingAnimation.rotation
    ..exitAnimation = HzLoadingAnimation.slideDown
    ..animationDuration = const Duration(milliseconds: 600)
    ..animationCurve = Curves.elasticOut;
}
```

### Custom Progress Indicator

You can use any widget as a progress indicator, including the popular `flutter_spinkit` package for beautiful animations:

```dart
// Add to pubspec.yaml:
// dependencies:
//   flutter_spinkit: ^5.2.2

import 'package:flutter_spinkit/flutter_spinkit.dart';

// Using flutter_spinkit animations
HzLoading.show(HzLoadingData(
  text: 'Loading with style...',
  progressIndicatorBuilder: () {
    return const SpinKitWave(
      color: Colors.blue,
      size: 50.0,
    );
  },
));

// More flutter_spinkit examples
HzLoading.show(HzLoadingData(
  progressIndicatorBuilder: () {
    return const SpinKitFadingCircle(
      color: Colors.purple,
      size: 60.0,
    );
  },
));

// Custom CircularProgressIndicator
HzLoading.show(HzLoadingData(
  progressIndicatorBuilder: () {
    return const SizedBox(
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        strokeWidth: 6,
        color: Colors.red,
      ),
    );
  },
));
```

#### Popular flutter_spinkit Options:
- `SpinKitWave` - Wave animation
- `SpinKitFadingCircle` - Fading circle animation  
- `SpinKitRotatingCircle` - Rotating circle
- `SpinKitThreeBounce` - Three bouncing dots
- `SpinKitCubeGrid` - Cube grid animation
- `SpinKitPulse` - Pulsing circle
- And 20+ more beautiful animations!

### Advanced Custom Text Builder

```dart
HzLoading.show(HzLoadingData(
  text: 'Loading...',
  textBuilder: (title) {
    return Column(
      children: [
        const Icon(Icons.cloud_download, size: 32, color: Colors.blue),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Please wait while we process your request...'),
      ],
    );
  },
));
```

### Complex Positioning

```dart
// Bottom-right corner with custom styling
HzLoading.show(HzLoadingData(
  text: 'Syncing...',
  position: HzLoadingPosition.custom,
  customAlignment: Alignment.bottomRight,
  margin: const EdgeInsets.all(24),
  maxWidth: 200,
  decoration: BoxDecoration(
    color: Colors.black87,
    borderRadius: BorderRadius.circular(8),
  ),
  textStyle: const TextStyle(color: Colors.white),
  progressColor: Colors.white,
));
```

## Best Practices

### ✅ Recommended Patterns

1. **Always hide loading screens**: Ensure you call `HzLoading.hide()` in both success and error cases
2. **Use try-finally blocks**: Wrap your async operations to guarantee loading screen dismissal
3. **Dispose progress notifiers**: Don't forget to dispose `ValueNotifier` instances
4. **Provide meaningful feedback**: Use descriptive text and appropriate progress indicators
5. **Configure defaults early**: Set up global configuration in your app's main() function
6. **Use withDefaults() for consistency**: Prefer `HzLoadingData.withDefaults()` to maintain consistent styling
7. **Leverage auto-dismiss**: Use auto-hide features to improve user experience
8. **Implement safety timeouts**: Always set maxDuration for long operations
9. **Handle theme changes**: Update configuration when switching themes
10. **Use appropriate animations**: Match animations to your app's design language
11. **Consider flutter_spinkit**: Use `flutter_spinkit: ^5.2.2` for beautiful progress indicator animations

```dart
// ✅ Proper error handling
Future<void> loadData() async {
  HzLoading.show(HzLoadingData(text: 'Loading...'));

  try {
    await apiCall();
  } catch (e) {
    // Handle error
    showErrorSnackBar(e);
  } finally {
    HzLoading.hide(); // Always hide
  }
}

// ✅ Auto-dismiss with progress
Future<void> uploadFile() async {
  ValueNotifier<int> progress = ValueNotifier<int>(0);
  
  HzLoading.show(HzLoadingData.withDefaults(
    text: 'Uploading...',
    progress: progress,
    autoHideOnComplete: true,
    autoHideDelay: const Duration(milliseconds: 500),
    maxDuration: const Duration(minutes: 10), // Safety timeout
  ));

  try {
    await uploadWithProgress(progress);
    // Will auto-hide on completion
  } catch (e) {
    HzLoading.hide();
    handleUploadError(e);
  } finally {
    progress.dispose(); // Always dispose
  }
}
```

### Configuration Best Practices

```dart
// ✅ Configure once in main()
void main() {
  HzLoading.instance
    ..materialColor = Colors.black.withAlpha(120)
    ..progressColor = Colors.blue
    ..defaultText = 'Please wait...'
    ..autoHideOnComplete = false // Set reasonable defaults
    ..maxDuration = const Duration(minutes: 5); // Safety timeout

  runApp(MyApp());
}

// ✅ Use withDefaults() for consistency
HzLoading.show(HzLoadingData.withDefaults(
  text: 'Uploading files...',
  autoHideOnComplete: true, // Override for this specific case
));

// ✅ Update configuration for theme changes
void updateTheme(bool isDark) {
  HzLoading.instance
    ..materialColor = isDark
        ? Colors.black.withAlpha(200)
        : Colors.black.withAlpha(100)
    ..decoration = BoxDecoration(
      color: isDark ? Colors.grey[800] : Colors.white,
      borderRadius: BorderRadius.circular(12),
    )
    ..textStyle = TextStyle(
      color: isDark ? Colors.white : Colors.black87,
    );
}
```

### ❌ Common Pitfalls to Avoid

```dart
// ❌ Don't forget to hide loading screens
Future<void> badExample() async {
  HzLoading.show(HzLoadingData(text: 'Loading...'));
  await apiCall();
  // Missing HzLoading.hide() - loading screen stays forever!
}

// ❌ Don't forget to dispose progress notifiers
Future<void> memoryLeak() async {
  ValueNotifier<int> progress = ValueNotifier<int>(0);
  HzLoading.show(HzLoadingData(progress: progress));
  // Missing progress.dispose() - memory leak!
}

// ❌ Don't use overly long maxDuration without user feedback
HzLoading.show(HzLoadingData(
  maxDuration: const Duration(hours: 1), // Too long!
));
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Run `flutter pub get`
3. Make your changes
4. Run tests: `flutter test`
5. Run the example: `cd example && flutter run`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.

## Support

If you find this package helpful, please give it a ⭐ on GitHub!

For issues and feature requests, please use the [GitHub issue tracker](https://github.com/yourusername/hz_loading_screen/issues).
#   h z * l o a d i n g * s c r e e n 
 
 
