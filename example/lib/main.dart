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
    HzLoadingScreen.show(HzLoadingData(
      text: 'Loading, please wait...',
      withTimer: false,
      materialColor: Colors.black.withAlpha(100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    ));

    await Future.delayed(const Duration(seconds: 3));

    HzLoadingScreen.hide();
  }

  void _customLoading() async {
    HzLoadingScreen.show(HzLoadingData(
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

    HzLoadingScreen.hide();
  }

  void _customLoading2() async {
    HzLoadingScreen.show(HzLoadingData(
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

    HzLoadingScreen.hide();
  }

  void _customLoading3() async {
    //with progress
    ValueNotifier<int> progress = ValueNotifier<int>(0);
    HzLoadingScreen.show(HzLoadingData(
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
    HzLoadingScreen.hide();
    progress.dispose();
  }

  void _customLoading4() async {
    //with progress
    ValueNotifier<int> progress = ValueNotifier<int>(0);
    HzLoadingScreen.show(HzLoadingData(
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
    HzLoadingScreen.hide();
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
              child: const Text('Show Custom Loading with Progress Builder'),
            ),
          ],
        ),
      ),
    );
  }
}
