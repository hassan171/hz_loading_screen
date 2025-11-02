import 'package:flutter/material.dart';
import 'package:hz_loading_screen/hz_loading_screen.dart';

void main() {
  // Configure global defaults for all loading screens
  HzLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..materialColor = Colors.black.withAlpha(120)
    ..progressColor = Colors.deepPurple
    ..closeIconColor = Colors.deepPurple
    ..textStyle = const TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    )
    ..showDecoration = true
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        return HzLoadingInitializer(child: child!);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  void _customLoading2() async {
    HzLoading.show(HzLoadingData(
      text: 'Custom Loading...',
      withTimer: false,
      textBuilder: (title) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              'This is a custom text builder for the loading screen.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        );
      },
      materialColor: Colors.blue.withAlpha(100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    ));

    await Future.delayed(const Duration(seconds: 4));

    HzLoading.hide();
  }

  void _customLoading3() async {
    //with progress
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
    for (int i = 0; i <= 100; i += 1) {
      await Future.delayed(const Duration(milliseconds: 50));
      progress.value = i;
    }
    HzLoading.hide();
    progress.dispose();
  }

  void _customLoading4() async {
    //with progress using linear indicator
    ValueNotifier<int> progress = ValueNotifier<int>(0);
    HzLoading.show(HzLoadingData(
      text: 'Loading with linear progress...',
      progress: progress,
      withTimer: false,
      useLinearProgress: true, // Use the new parameter instead of progressBuilder
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

  void _defaultConfigLoading() async {
    // This will use the default configuration set in main()
    HzLoading.show();

    await Future.delayed(const Duration(seconds: 3));

    HzLoading.hide();
  }

  void _defaultConfigWithOverride() async {
    // Use defaults but override specific values
    HzLoading.show(HzLoadingData.withDefaults(
      text: 'Using defaults with custom text!',
      progressColor: Colors.orange, // Override just the progress color
    ));

    await Future.delayed(const Duration(seconds: 3));

    HzLoading.hide();
  }

  void _showDecorationDemo() async {
    // Show loading with decoration even without text
    HzLoading.show(HzLoadingData(
      showDecoration: true,
      withTimer: false,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      progressColor: Colors.blue,
    ));

    await Future.delayed(const Duration(seconds: 2));

    HzLoading.hide();
  }

  void _linearProgressDemo() async {
    // Show with linear progress indicator
    ValueNotifier<int> progress = ValueNotifier<int>(0);
    HzLoading.show(HzLoadingData(
      text: 'Linear Progress Demo',
      progress: progress,
      withTimer: false,
      useLinearProgress: true, // Show linear indicator
    ));

    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      progress.value = i;
    }

    HzLoading.hide();
    progress.dispose();
  }

  void _textProgressDemo() async {
    // Show with text progress percentage
    ValueNotifier<int> progress = ValueNotifier<int>(0);
    HzLoading.show(HzLoadingData(
      text: 'Text Progress Demo',
      progress: progress,
      withTimer: false,
      useLinearProgress: false, // Show text percentage
    ));

    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      progress.value = i;
    }

    HzLoading.hide();
    progress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _simpleLoading,
              child: const Text('Show Simple Loading'),
            ),
            ElevatedButton(
              onPressed: _customLoading,
              child: const Text('Show Custom Loading'),
            ),
            ElevatedButton(
              onPressed: _customLoading2,
              child: const Text('Show Custom Loading 2'),
            ),
            ElevatedButton(
              onPressed: _customLoading3,
              child: const Text('Show Custom Loading with Progress'),
            ),
            ElevatedButton(
              onPressed: _customLoading4,
              child: const Text('Show Custom Loading with Linear Progress'),
            ),
            ElevatedButton(
              onPressed: _defaultConfigLoading,
              child: const Text('Show Default Config Loading'),
            ),
            ElevatedButton(
              onPressed: _defaultConfigWithOverride,
              child: const Text('Show Default Config with Override'),
            ),
            ElevatedButton(
              onPressed: _showDecorationDemo,
              child: const Text('Show Decoration Demo'),
            ),
            ElevatedButton(
              onPressed: _linearProgressDemo,
              child: const Text('Linear Progress Demo'),
            ),
            ElevatedButton(
              onPressed: _textProgressDemo,
              child: const Text('Text Progress Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
