import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hz_loading_screen/hz_loading_screen.dart';

void main() {
  group('HzLoadingScreen Tests', () {
    tearDown(() {
      // Reset loading state after each test
      HzLoadingScreen.hide();
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

      // Should have overlay structure
      expect(find.byType(Overlay), findsOneWidget);
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
      expect(HzLoadingScreen.isVisible, false);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Show loading screen
      HzLoadingScreen.show(HzLoadingData(text: 'Loading...'));
      await tester.pump();

      // Should be visible now
      expect(HzLoadingScreen.isVisible, true);
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Hide loading screen
      HzLoadingScreen.hide();
      await tester.pump();

      // Should be hidden now
      expect(HzLoadingScreen.isVisible, false);
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
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
      expect(HzLoadingScreen.isVisible, false);
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
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

      HzLoadingScreen.show(HzLoadingData(
        text: 'No indicator',
        showProgressIndicator: false,
      ));
      await tester.pump();

      // Should show text but no progress indicator
      expect(find.text('No indicator'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    test('HzLoadingScreen singleton behavior', () {
      final instance1 = HzLoadingScreen();
      final instance2 = HzLoadingScreen();

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

      expect(data.isVisible, true);
      expect(data.withTimer, true);
      expect(data.text, null);
      expect(data.progressColor, null);
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
      HzLoadingScreen.show(HzLoadingData(
        text: 'First message',
      ));
      await tester.pump();

      expect(find.text('First message'), findsOneWidget);

      // Second show call should update
      HzLoadingScreen.show(HzLoadingData(
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
        HzLoadingScreen.show(HzLoadingData(text: 'Test'));
      }, returnsNormally);

      expect(HzLoadingScreen.isVisible, true); // State should still update
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
}
