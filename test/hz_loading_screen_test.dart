import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_loading_screen/hz_loading_screen.dart';

void main() {
  group('HzLoading Tests', () {
    tearDown(() {
      // Reset loading state after each test
      HzLoading.hide();
    });

    testWidgets('HzLoadingInitializer creates overlay structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(
              child: child!,
            );
          },
          home: const Scaffold(
            body: Center(
              child: Text('Test Content'),
            ),
          ),
        ),
      );

      // Should find the test content
      expect(find.text('Test Content'), findsOneWidget);

      // Should have at least one overlay (there might be multiple due to MaterialApp)
      expect(find.byType(Overlay), findsAtLeastNWidgets(1));
    });

    testWidgets('Loading screen shows and hides correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(
            body: Center(child: Text('Main Content')),
          ),
        ),
      );

      // Initially not visible
      expect(HzLoading.isVisible, false);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Show loading screen
      HzLoading.show(HzLoadingData(text: 'Loading...'));
      await tester.pump();

      // Should be visible now
      expect(HzLoading.isVisible, true);
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Hide loading screen
      HzLoading.hide();
      await tester.pump();

      // Should be hidden now
      expect(HzLoading.isVisible, false);
      expect(find.text('Loading...'), findsNothing);
    });

    testWidgets('Loading screen with custom text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      HzLoading.show(HzLoadingData(
        text: 'Custom Loading Message',
      ));
      await tester.pump();

      expect(find.text('Custom Loading Message'), findsOneWidget);
    });

    testWidgets('Loading screen without text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      HzLoading.show(HzLoadingData(
        text: null, // No text
      ));
      await tester.pump();

      // Should show progress indicator but no text
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('Loading screen with progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      ValueNotifier<int> progress = ValueNotifier<int>(0);

      HzLoading.show(HzLoadingData(
        text: 'Loading with progress...',
        progress: progress,
      ));
      await tester.pump();

      // Should show initial progress
      expect(find.text('(0%)'), findsOneWidget);

      // Update progress
      progress.value = 50;
      await tester.pump();

      // Should show updated progress
      expect(find.text('(50%)'), findsOneWidget);

      // Update to completion
      progress.value = 100;
      await tester.pump();

      // Should show completed progress
      expect(find.text('(100%)'), findsOneWidget);

      progress.dispose();
    });

    testWidgets('Loading screen with custom progress builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      ValueNotifier<int> progress = ValueNotifier<int>(25);

      HzLoading.show(HzLoadingData(
        text: 'Custom progress...',
        progress: progress,
        progressBuilder: (progressValue) {
          return Text('Progress: $progressValue%');
        },
      ));
      await tester.pump();

      // Should show custom progress text
      expect(find.text('Progress: 25%'), findsOneWidget);

      progress.dispose();
    });

    testWidgets('Loading screen with custom text builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      HzLoading.show(HzLoadingData(
        text: 'Custom Text',
        textBuilder: (title) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download),
              SizedBox(height: 8),
              Text('Custom: $title'),
            ],
          );
        },
      ));
      await tester.pump();

      // Should show custom text layout
      expect(find.byIcon(Icons.download), findsOneWidget);
      expect(find.text('Custom: Custom Text'), findsOneWidget);
    });

    testWidgets('Loading screen with custom progress indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      HzLoading.show(HzLoadingData(
        progressIndicatorBuilder: () {
          return Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('LOAD'),
            ),
          );
        },
      ));
      await tester.pump();

      // Should show custom progress indicator
      expect(find.text('LOAD'), findsOneWidget);

      // Find the container with red color
      final container = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('LOAD'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect((container.decoration as BoxDecoration).color, Colors.red);
    });

    testWidgets('Loading screen timer functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      bool onClosedCalled = false;

      HzLoading.show(HzLoadingData(
        text: 'Timer test...',
        withTimer: true,
        duration: const Duration(milliseconds: 100),
        onClosed: () {
          onClosedCalled = true;
        },
      ));
      await tester.pump();

      // Initially no close button
      expect(find.byIcon(Icons.close), findsNothing);

      // Wait for timer to expire
      await tester.pump(const Duration(milliseconds: 150));

      // Close button should appear
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Tap close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Loading should be hidden and callback called
      expect(HzLoading.isVisible, false);
      expect(onClosedCalled, true);
    });

    testWidgets('Loading screen without timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      HzLoading.show(HzLoadingData(
        text: 'No timer...',
        withTimer: false,
      ));
      await tester.pump();

      // Wait some time
      await tester.pump(const Duration(seconds: 1));

      // Close button should never appear
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('Loading screen with custom styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      HzLoading.show(HzLoadingData(
        text: 'Styled loading',
        materialColor: Colors.red.withAlpha(100),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        progressColor: Colors.yellow,
      ));
      await tester.pump();

      // Check if text is displayed
      expect(find.text('Styled loading'), findsOneWidget);

      // Check if progress indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify progress indicator color
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.color, Colors.yellow);
    });

    testWidgets('Loading screen hides progress indicator when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      HzLoading.show(HzLoadingData(
        text: 'No indicator',
        showProgressIndicator: false,
      ));
      await tester.pump();

      // Should show text but no progress indicator
      expect(find.text('No indicator'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    test('HzLoading singleton behavior', () {
      final instance1 = HzLoading();
      final instance2 = HzLoading();

      // Should be the same instance (singleton)
      expect(identical(instance1, instance2), true);
    });

    test('HzLoadingData configuration', () {
      final data = HzLoadingData(
        isVisible: false,
        withTimer: false,
        text: 'Test',
        progressColor: Colors.red,
      );

      expect(data.isVisible, false);
      expect(data.withTimer, false);
      expect(data.text, 'Test');
      expect(data.progressColor, Colors.red);
    });

    test('HzLoadingData default values', () {
      final data = HzLoadingData();

      expect(data.isVisible, false);
      expect(data.withTimer, true);
      expect(data.text, null);
      expect(data.progressColor, null);
      expect(data.showDecoration, null);
    });

    test('HzLoadingData showDecoration parameter', () {
      final dataWithDecorationTrue = HzLoadingData(showDecoration: true);
      final dataWithDecorationFalse = HzLoadingData(showDecoration: false);
      final dataWithDecorationNull = HzLoadingData();

      expect(dataWithDecorationTrue.showDecoration, true);
      expect(dataWithDecorationFalse.showDecoration, false);
      expect(dataWithDecorationNull.showDecoration, null);
    });

    test('HzLoadingData useLinearProgress parameter', () {
      final dataWithLinearProgressTrue = HzLoadingData(useLinearProgress: true);
      final dataWithLinearProgressFalse = HzLoadingData(useLinearProgress: false);
      final dataWithLinearProgressNull = HzLoadingData();

      expect(dataWithLinearProgressTrue.useLinearProgress, true);
      expect(dataWithLinearProgressFalse.useLinearProgress, false);
      expect(dataWithLinearProgressNull.useLinearProgress, null);
    });

    testWidgets('Multiple show calls update configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      // First show call
      HzLoading.show(HzLoadingData(
        text: 'First message',
      ));
      await tester.pump();

      expect(find.text('First message'), findsOneWidget);

      // Second show call should update
      HzLoading.show(HzLoadingData(
        text: 'Second message',
      ));
      await tester.pump();

      expect(find.text('First message'), findsNothing);
      expect(find.text('Second message'), findsOneWidget);
    });

    testWidgets('Loading screen works without HzLoadingInitializer in test environment', (WidgetTester tester) async {
      // This test ensures the loading screen degrades gracefully
      // when HzLoadingInitializer is not present
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('No Initializer')),
          ),
        ),
      );

      // This should not throw an error, even though it won't display
      expect(() {
        HzLoading.show(HzLoadingData(text: 'Test'));
      }, returnsNormally);

      expect(HzLoading.isVisible, true); // State should still update
    });
  });

  group('HzLoadingData Tests', () {
    test('Creates with all properties', () {
      final textBuilder = (String text) => Text(text);
      final progressBuilder = (int progress) => Text('$progress%');
      final progressIndicatorBuilder = () => CircularProgressIndicator();
      final progress = ValueNotifier<int>(50);
      final onClosed = () {};

      final data = HzLoadingData(
        isVisible: false,
        withTimer: false,
        duration: const Duration(seconds: 5),
        onClosed: onClosed,
        text: 'Test Text',
        textBuilder: textBuilder,
        progress: progress,
        materialColor: Colors.red,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.blue),
        progressIndicatorBuilder: progressIndicatorBuilder,
        progressColor: Colors.green,
        closeIcon: Icons.clear,
        closeIconColor: Colors.yellow,
        progressBuilder: progressBuilder,
        textStyle: const TextStyle(fontSize: 20),
        progressTextStyle: const TextStyle(fontSize: 16),
        showProgressIndicator: false,
      );

      expect(data.isVisible, false);
      expect(data.withTimer, false);
      expect(data.duration, const Duration(seconds: 5));
      expect(data.onClosed, onClosed);
      expect(data.text, 'Test Text');
      expect(data.textBuilder, textBuilder);
      expect(data.progress, progress);
      expect(data.materialColor, Colors.red);
      expect(data.padding, const EdgeInsets.all(20));
      expect(data.decoration?.color, Colors.blue);
      expect(data.progressIndicatorBuilder, progressIndicatorBuilder);
      expect(data.progressColor, Colors.green);
      expect(data.closeIcon, Icons.clear);
      expect(data.closeIconColor, Colors.yellow);
      expect(data.progressBuilder, progressBuilder);
      expect(data.textStyle?.fontSize, 20);
      expect(data.progressTextStyle?.fontSize, 16);
      expect(data.showProgressIndicator, false);

      progress.dispose();
    });
  });

  group('HzLoadingConfig Tests', () {
    tearDown(() {
      // Reset configuration after each test
      HzLoadingConfig.instance.reset();
    });

    test('Configuration singleton behavior', () {
      final instance1 = HzLoadingConfig.instance;
      final instance2 = HzLoadingConfig.instance;

      // Should be the same instance (singleton)
      expect(identical(instance1, instance2), true);
    });

    test('Configuration default values', () {
      final config = HzLoadingConfig.instance;

      // All values should be null by default
      expect(config.displayDuration, null);
      expect(config.defaultText, null);
      expect(config.materialColor, null);
      expect(config.padding, null);
      expect(config.decoration, null);
      expect(config.progressColor, null);
      expect(config.textStyle, null);
      expect(config.progressTextStyle, null);
      expect(config.closeIcon, null);
      expect(config.closeIconColor, null);
      expect(config.showProgressIndicator, null);
      expect(config.withTimer, null);
      expect(config.showDecoration, null);
      expect(config.useLinearProgress, null);
      expect(config.onClosed, null);
    });

    test('Configuration setter and getter', () {
      final config = HzLoadingConfig.instance;
      final duration = Duration(seconds: 5);
      final onClosed = () {};

      config.displayDuration = duration;
      config.defaultText = 'Test Text';
      config.materialColor = Colors.red;
      config.progressColor = Colors.blue;
      config.withTimer = false;
      config.showDecoration = true;
      config.useLinearProgress = true;
      config.onClosed = onClosed;

      expect(config.displayDuration, duration);
      expect(config.defaultText, 'Test Text');
      expect(config.materialColor, Colors.red);
      expect(config.progressColor, Colors.blue);
      expect(config.withTimer, false);
      expect(config.showDecoration, true);
      expect(config.useLinearProgress, true);
      expect(config.onClosed, onClosed);
    });

    test('Configuration reset', () {
      final config = HzLoadingConfig.instance;

      // Set some values
      config.displayDuration = Duration(seconds: 5);
      config.defaultText = 'Test';
      config.materialColor = Colors.red;

      // Reset
      config.reset();

      // All values should be null again
      expect(config.displayDuration, null);
      expect(config.defaultText, null);
      expect(config.materialColor, null);
    });

    test('Configuration copy', () {
      final config = HzLoadingConfig.instance;

      config.displayDuration = Duration(seconds: 3);
      config.defaultText = 'Original';
      config.materialColor = Colors.blue;

      final copy = config.copy();

      expect(copy.displayDuration, Duration(seconds: 3));
      expect(copy.defaultText, 'Original');
      expect(copy.materialColor, Colors.blue);

      // Modify original
      config.defaultText = 'Modified';

      // Copy should remain unchanged
      expect(copy.defaultText, 'Original');
    });

    testWidgets('HzLoadingData.withDefaults uses configuration', (WidgetTester tester) async {
      // Configure defaults
      HzLoadingConfig.instance
        ..defaultText = 'Default Text'
        ..materialColor = Colors.red
        ..progressColor = Colors.green
        ..withTimer = false;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      // Create loading data with defaults
      final data = HzLoadingData.withDefaults();

      expect(data.text, 'Default Text');
      expect(data.materialColor, Colors.red);
      expect(data.progressColor, Colors.green);
      expect(data.withTimer, false);
    });

    testWidgets('HzLoadingData.withDefaults allows overrides', (WidgetTester tester) async {
      // Configure defaults
      HzLoadingConfig.instance
        ..defaultText = 'Default Text'
        ..materialColor = Colors.red
        ..progressColor = Colors.green;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      // Create loading data with defaults and overrides
      final data = HzLoadingData.withDefaults(
        text: 'Override Text',
        materialColor: Colors.blue,
        // progressColor should use default (Colors.green)
      );

      expect(data.text, 'Override Text'); // Overridden
      expect(data.materialColor, Colors.blue); // Overridden
      expect(data.progressColor, Colors.green); // From config
    });

    testWidgets('HzLoading.instance provides config access', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      // Test that HzLoading.instance is the same as HzLoadingConfig.instance
      expect(identical(HzLoading.instance, HzLoadingConfig.instance), true);

      // Test configuration via HzLoading.instance
      HzLoading.instance.defaultText = 'Via HzLoading';
      expect(HzLoadingConfig.instance.defaultText, 'Via HzLoading');
    });

    testWidgets('HzLoading.show uses configuration when no data provided', (WidgetTester tester) async {
      // Configure defaults
      HzLoadingConfig.instance
        ..defaultText = 'Config Text'
        ..materialColor = Colors.purple;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return HzLoadingInitializer(child: child!);
          },
          home: const Scaffold(),
        ),
      );

      // Show loading without providing data
      HzLoading.show();
      await tester.pump();

      // Should use the configured defaults
      expect(find.text('Config Text'), findsOneWidget);
    });
  });
}
