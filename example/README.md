# example

# Hz Loading Screen Example

This example demonstrates all the features and capabilities of the Hz Loading Screen package.

## What's Included

This example app showcases:

1. **Simple Loading Screen** - Basic loading with text and default styling
2. **Custom Loading Screen** - Custom colors, styling, and progress indicators
3. **Custom Text Builder** - Advanced text layouts with multiple elements
4. **Progress Tracking** - Real-time progress updates with percentage display
5. **Custom Progress Builder** - Linear progress bars and custom progress widgets

## Running the Example

### Prerequisites

- Flutter SDK (>=3.5.4)
- Dart SDK (>=3.5.4)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Steps

1. **Navigate to the example directory:**

   ```bash
   cd example
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Platform Support

This example runs on all Flutter-supported platforms:

- **Android** - Run with `flutter run` or use Android Studio
- **iOS** - Run with `flutter run` or use Xcode
- **Web** - Run with `flutter run -d chrome`
- **Windows** - Run with `flutter run -d windows`
- **macOS** - Run with `flutter run -d macos`
- **Linux** - Run with `flutter run -d linux`

## Code Examples

### 1. Simple Loading Screen

```dart
void _simpleLoading() async {
  HzLoading.show(HzLoadingData(
    text: 'Loading, please wait...',
    withTimer: false,
    materialColor: Colors.black.withAlpha(100),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  ));

  await Future.delayed(const Duration(seconds: 3));

  HzLoading.hide();
}
```

### 2. Custom Loading with Styling

```dart
void _customLoading() async {
  HzLoading.show(HzLoadingData(
    text: 'Custom Loading...',
    progressIndicatorBuilder: () {
      return CircularProgressIndicator(
        color: Colors.red,
        strokeWidth: 6,
      );
    },
    textBuilder: (title) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    },
    materialColor: Colors.blue.withAlpha(100),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
    ),
  ));

  await Future.delayed(const Duration(seconds: 4));

  HzLoading.hide();
}
```

### 3. Progress Tracking

```dart
void _progressLoading() async {
  ValueNotifier<int> progress = ValueNotifier<int>(0);

  HzLoading.show(HzLoadingData(
    text: 'Loading with progress...',
    progress: progress,
    withTimer: false,
    materialColor: Colors.green.withAlpha(100),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
  ));

  // Simulate progress updates
  for (int i = 0; i <= 100; i += 1) {
    await Future.delayed(const Duration(milliseconds: 50));
    progress.value = i;
  }

  HzLoading.hide();
  progress.dispose(); // Don't forget to dispose!
}
```

### 4. Custom Progress Builder

```dart
void _customProgressBuilder() async {
  ValueNotifier<int> progress = ValueNotifier<int>(0);

  HzLoading.show(HzLoadingData(
    text: 'Loading with progress...',
    progress: progress,
    withTimer: false,
    progressBuilder: (progress) {
      return SizedBox(
        width: 200,
        child: Column(
          children: [
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress / 100,
              color: Colors.blue,
              backgroundColor: Colors.grey.withAlpha(100),
            ),
            const SizedBox(height: 10),
            Text(
              '${progress.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    },
    materialColor: Colors.green.withAlpha(100),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
  ));

  for (int i = 0; i <= 100; i += 1) {
    await Future.delayed(const Duration(milliseconds: 50));
    progress.value = i;
  }

  HzLoading.hide();
  progress.dispose();
}
```

## Key Learning Points

### 1. Setup Requirements

Always wrap your app with `HzLoadingInitializer`:

```dart
MaterialApp(
  builder: (context, child) {
    return HzLoadingInitializer(child: child!);
  },
  // ... other properties
)
```

### 2. Basic Usage Pattern

```dart
// Show loading
HzLoading.show(HzLoadingData(/* configuration */));

// Perform async work
await someAsyncOperation();

// Hide loading
HzLoading.hide();
```

### 3. Error Handling

Always use try-finally to ensure loading is hidden:

```dart
void performOperation() async {
  HzLoading.show(HzLoadingData(text: 'Processing...'));

  try {
    await riskyOperation();
  } catch (e) {
    showErrorDialog(e.toString());
  } finally {
    HzLoading.hide(); // Always hide loading
  }
}
```

### 4. Progress Management

Remember to dispose progress notifiers:

```dart
ValueNotifier<int> progress = ValueNotifier<int>(0);

try {
  HzLoading.show(HzLoadingData(progress: progress));
  // ... use progress
} finally {
  HzLoading.hide();
  progress.dispose(); // Clean up
}
```

## Customization Options

The example demonstrates these customization features:

- **Colors**: `materialColor`, `progressColor`, `closeIconColor`
- **Styling**: `decoration`, `padding`, `textStyle`, `progressTextStyle`
- **Behavior**: `withTimer`, `duration`, `onClosed`
- **Content**: `text`, `textBuilder`, `progressBuilder`
- **Indicators**: `progressIndicatorBuilder`, `showProgressIndicator`
- **Icons**: `closeIcon`

## Troubleshooting

### Loading Screen Not Appearing

1. Ensure `HzLoadingInitializer` wraps your app
2. Check that `isVisible` is `true` (default)
3. Verify you're calling `HzLoading.show()`

### Progress Not Updating

1. Make sure you're using `ValueNotifier<int>`
2. Update progress with `progress.value = newValue`
3. Ensure progress values are between 0-100

### Memory Leaks

1. Always call `HzLoading.hide()` in finally blocks
2. Dispose `ValueNotifier` instances when done
3. Use timer-based close buttons for user control

## Package Information

This example uses the Hz Loading Screen package. For more information:

- [Package Documentation](../README.md)
- [API Reference](../lib/)
- [Changelog](../CHANGELOG.md)

## Next Steps

After running this example:

1. Try modifying the configurations to see different effects
2. Implement loading screens in your own app
3. Experiment with custom builders and styling
4. Add progress tracking to your async operations
