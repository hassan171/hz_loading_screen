# Hz Loading Screen

A customizable and easy-to-use Flutter package for displaying overlay loading screens that can be accessed from anywhere in your app. Perfect for showing loading states during network requests, file operations, or any time-consuming tasks.

## Features

- **Global Access**: Show/hide loading screens from anywhere in your app without context
- **Highly Customizable**: Customize colors, text, animations, and layout
- **Progress Support**: Display progress indicators with percentage or custom builders
- **Timer-based Close**: Automatic close button that appears after a specified duration
- **Multiple Styles**: Support for circular progress, linear progress, and custom indicators
- **Overlay System**: Non-intrusive overlay that doesn't affect your app's navigation
- **Material Design**: Built with Material Design principles in mind

## Screenshots

| Simple Loading | Custom Loading | Progress Loading |
|---------------|---------------|-----------------|
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

## Usage

### Simple Loading Screen

```dart
// Show loading
HzLoadingScreen.show(HzLoadingData(
  text: 'Loading, please wait...',
  withTimer: false,
));

// Perform your async operation
await Future.delayed(const Duration(seconds: 3));

// Hide loading
HzLoadingScreen.hide();
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

### Loading with Progress

```dart
ValueNotifier<int> progress = ValueNotifier<int>(0);

HzLoadingScreen.show(HzLoadingData(
  text: 'Downloading...',
  progress: progress,
  withTimer: false,
));

// Simulate progress
for (int i = 0; i <= 100; i += 10) {
  await Future.delayed(const Duration(milliseconds: 200));
  progress.value = i;
}

HzLoadingScreen.hide();
progress.dispose();
```

### Custom Progress Builder

```dart
ValueNotifier<int> progress = ValueNotifier<int>(0);

HzLoadingScreen.show(HzLoadingData(
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
HzLoadingScreen.show(HzLoadingData(
  text: 'Loading...',
  withTimer: true,
  duration: const Duration(seconds: 3), // Close button appears after 3 seconds
  onClosed: () {
    print('Loading was closed by user');
  },
));
```

## API Reference

### HzLoadingScreen

The main class for controlling the loading screen.

#### Static Methods

- `show(HzLoadingData? loadingData)` - Show the loading screen
- `hide()` - Hide the loading screen
- `isVisible` - Get current visibility state

### HzLoadingData

Configuration class for customizing the loading screen appearance and behavior.

#### Properties

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `isVisible` | `bool` | Whether the loading screen is visible | `true` |
| `withTimer` | `bool` | Show close button after duration | `true` |
| `duration` | `Duration?` | Time before close button appears | `Duration(seconds: 2)` |
| `onClosed` | `Function?` | Callback when loading is closed | `null` |
| `text` | `String?` | Loading text to display | `null` |
| `textBuilder` | `Widget Function(String)?` | Custom text widget builder | `null` |
| `progress` | `ValueListenable<int>?` | Progress value notifier (0-100) | `null` |
| `materialColor` | `Color?` | Background overlay color | `Colors.black.withAlpha(150)` |
| `padding` | `EdgeInsetsGeometry?` | Container padding | `EdgeInsets.all(16)` |
| `decoration` | `BoxDecoration?` | Container decoration | Auto-generated |
| `progressIndicatorBuilder` | `Widget Function()?` | Custom progress indicator | `CircularProgressIndicator` |
| `progressColor` | `Color?` | Progress indicator color | `Colors.blue` |
| `closeIcon` | `IconData?` | Close button icon | `Icons.close` |
| `closeIconColor` | `Color?` | Close button color | `Colors.blue` |
| `progressBuilder` | `Widget Function(int)?` | Custom progress display | Default percentage text |
| `textStyle` | `TextStyle?` | Text styling | Default style |
| `progressTextStyle` | `TextStyle?` | Progress text styling | Default style |
| `showProgressIndicator` | `bool?` | Show/hide progress indicator | `true` |

### HzLoadingInitializer

Widget that initializes the loading system. Must wrap your app.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `child` | `Widget` | Your app widget |

## Examples

The package includes a comprehensive example app demonstrating various use cases:

- Simple loading screen
- Custom styled loading
- Progress-based loading
- Custom progress builders
- Timer-based interactions

To run the example:

```bash
cd example
flutter run
```

## Advanced Usage

### Custom Progress Indicator

```dart
HzLoadingScreen.show(HzLoadingData(
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

### Custom Text Builder

```dart
HzLoadingScreen.show(HzLoadingData(
  text: 'Loading...',
  textBuilder: (title) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text('Please wait while we process your request...'),
      ],
    );
  },
));
```

## Best Practices

1. **Always hide loading screens**: Ensure you call `HzLoadingScreen.hide()` in both success and error cases
2. **Use try-finally blocks**: Wrap your async operations to guarantee loading screen dismissal
3. **Dispose progress notifiers**: Don't forget to dispose `ValueNotifier` instances
4. **Provide feedback**: Use meaningful text and progress indicators
5. **Handle user interactions**: Implement `onClosed` callback for user-initiated dismissals

```dart
void loadData() async {
  HzLoadingScreen.show(HzLoadingData(text: 'Loading...'));
  
  try {
    await apiCall();
  } catch (e) {
    // Handle error
  } finally {
    HzLoadingScreen.hide();
  }
}
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
#   h z _ l o a d i n g _ s c r e e n  
 