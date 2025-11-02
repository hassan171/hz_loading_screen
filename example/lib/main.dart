import 'dart:developer';

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

  void _autoDismissDemo() async {
    // Demo auto-dismiss functionality with progress
    ValueNotifier<int> progress = ValueNotifier<int>(0);
    HzLoading.show(HzLoadingData(
      text: 'Auto-dismiss Demo\nWill auto-hide at 100%',
      progress: progress,
      withTimer: false,
      autoHideOnComplete: true,
      autoHideDelay: const Duration(milliseconds: 800),
      maxDuration: const Duration(seconds: 10), // Safety timeout
      onAutoHide: () {
        print('Auto-dismiss demo completed!');
      },
    ));

    // Simulate progress
    for (int i = 0; i <= 100; i += 2) {
      await Future.delayed(const Duration(milliseconds: 80));
      progress.value = i;
    }

    // No need to call HzLoading.hide() - it will auto-hide!
    progress.dispose();
  }

  String _text = 'Loading...';
  bool _withTimer = true;
  bool _showProgressIndicator = true;
  bool _showDecoration = false;
  bool _useLinearProgress = false;
  HzLoadingAnimation _entranceAnimation = HzLoadingAnimation.fade;
  HzLoadingAnimation _exitAnimation = HzLoadingAnimation.fade;

  // Blur and backdrop effect variables
  bool _enableBackdropBlur = false;
  double _backdropBlurSigma = 5.0;
  bool _enableBackdropFilter = false;
  String _backdropFilterType = 'none'; // 'none', 'darken', 'lighten', 'color'

  // Position and layout variables
  HzLoadingPosition _position = HzLoadingPosition.center;
  Alignment _customAlignment = Alignment.center;
  bool _useMargin = false;
  double _marginValue = 20.0;
  bool _useMaxWidth = false;
  double _maxWidth = 300.0;
  bool _useMaxHeight = false;
  double _maxHeight = 200.0;

  // Auto-dismiss variables
  bool _autoHideOnComplete = false;
  bool _useAutoHideDelay = false;
  double _autoHideDelayValue = 1.0; // seconds
  bool _useMaxDuration = false;
  double _maxDurationValue = 30.0; // seconds

  void _showLoadingScreen() async {
    // Create backdrop color filter based on selected type
    ColorFilter? backdropColorFilter;
    if (_enableBackdropFilter && _backdropFilterType != 'none') {
      switch (_backdropFilterType) {
        case 'darken':
          backdropColorFilter = ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.multiply,
          );
          break;
        case 'lighten':
          backdropColorFilter = ColorFilter.mode(
            Colors.white.withOpacity(0.3),
            BlendMode.screen,
          );
          break;
        case 'color':
          backdropColorFilter = ColorFilter.mode(
            Colors.blue.withOpacity(0.2),
            BlendMode.overlay,
          );
          break;
      }
    }

    HzLoading.show(HzLoadingData(
      text: _text.isEmpty ? null : _text,
      withTimer: _withTimer,
      showProgressIndicator: _showProgressIndicator,
      showDecoration: _showDecoration,
      useLinearProgress: _useLinearProgress,
      entranceAnimation: _entranceAnimation,
      exitAnimation: _exitAnimation,
      enableBackdropBlur: _enableBackdropBlur,
      backdropBlurSigma: _backdropBlurSigma,
      enableBackdropFilter: _enableBackdropFilter,
      backdropColorFilter: backdropColorFilter,
      position: _position,
      customAlignment: _position == HzLoadingPosition.custom ? _customAlignment : null,
      margin: _useMargin ? EdgeInsets.all(_marginValue) : null,
      maxWidth: _useMaxWidth ? _maxWidth : null,
      maxHeight: _useMaxHeight ? _maxHeight : null,
      autoHideOnComplete: _autoHideOnComplete,
      autoHideDelay: _useAutoHideDelay ? Duration(milliseconds: (_autoHideDelayValue * 1000).round()) : null,
      onAutoHide: () {
        log('Loading auto-hidden!');
      },
      maxDuration: _useMaxDuration ? Duration(seconds: _maxDurationValue.round()) : null,
    ));

    // Wait a bit and then hide (unless auto-dismiss is enabled)
    if (!_autoHideOnComplete && !_useMaxDuration) {
      await Future.delayed(const Duration(seconds: 5));
      HzLoading.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showLoadingScreen,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Show Loading'),
        tooltip: 'Show loading screen with current configuration',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Interactive Controls',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Loading Text',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _text = value),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('With Timer'),
                subtitle: const Text('Auto-hide after delay'),
                value: _withTimer,
                onChanged: (value) => setState(() => _withTimer = value),
              ),
              SwitchListTile(
                title: const Text('Show Progress Indicator'),
                subtitle: const Text('Display spinning indicator'),
                value: _showProgressIndicator,
                onChanged: (value) => setState(() => _showProgressIndicator = value),
              ),
              SwitchListTile(
                title: const Text('Show Decoration'),
                subtitle: const Text('Show background container'),
                value: _showDecoration,
                onChanged: (value) => setState(() => _showDecoration = value),
              ),
              SwitchListTile(
                title: const Text('Use Linear Progress'),
                subtitle: const Text('Linear instead of circular'),
                value: _useLinearProgress,
                onChanged: (value) => setState(() => _useLinearProgress = value),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<HzLoadingAnimation>(
                      decoration: const InputDecoration(
                        labelText: 'Entrance Animation',
                        border: OutlineInputBorder(),
                      ),
                      value: _entranceAnimation,
                      items: HzLoadingAnimation.values.map((animation) {
                        return DropdownMenuItem(
                          value: animation,
                          child: Text(animation.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _entranceAnimation = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<HzLoadingAnimation>(
                      decoration: const InputDecoration(
                        labelText: 'Exit Animation',
                        border: OutlineInputBorder(),
                      ),
                      value: _exitAnimation,
                      items: HzLoadingAnimation.values.map((animation) {
                        return DropdownMenuItem(
                          value: animation,
                          child: Text(animation.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _exitAnimation = value);
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Blur and Backdrop Effects Section
              SwitchListTile(
                title: const Text('Enable Backdrop Blur'),
                subtitle: const Text('Blur the background content'),
                value: _enableBackdropBlur,
                onChanged: (value) => setState(() => _enableBackdropBlur = value),
              ),

              if (_enableBackdropBlur) ...[
                const SizedBox(height: 8),
                Text('Blur Intensity: ${_backdropBlurSigma.round()}'),
                Slider(
                  value: _backdropBlurSigma,
                  min: 1.0,
                  max: 20.0,
                  divisions: 19,
                  label: _backdropBlurSigma.round().toString(),
                  onChanged: (value) => setState(() => _backdropBlurSigma = value),
                ),
              ],

              SwitchListTile(
                title: const Text('Enable Backdrop Filter'),
                subtitle: const Text('Apply color effects to background'),
                value: _enableBackdropFilter,
                onChanged: (value) => setState(() => _enableBackdropFilter = value),
              ),

              if (_enableBackdropFilter) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Backdrop Filter Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _backdropFilterType,
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('None')),
                    DropdownMenuItem(value: 'darken', child: Text('Darken')),
                    DropdownMenuItem(value: 'lighten', child: Text('Lighten')),
                    DropdownMenuItem(value: 'color', child: Text('Blue Overlay')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _backdropFilterType = value);
                    }
                  },
                ),
              ],

              const SizedBox(height: 24),

              // Position & Layout Section
              Text(
                'Position & Layout Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<HzLoadingPosition>(
                decoration: const InputDecoration(
                  labelText: 'Position',
                  border: OutlineInputBorder(),
                ),
                value: _position,
                items: HzLoadingPosition.values.map((position) {
                  return DropdownMenuItem(
                    value: position,
                    child: Text(position.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _position = value);
                  }
                },
              ),

              if (_position == HzLoadingPosition.custom) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<Alignment>(
                  decoration: const InputDecoration(
                    labelText: 'Custom Alignment',
                    border: OutlineInputBorder(),
                  ),
                  value: _customAlignment,
                  items: const [
                    DropdownMenuItem(value: Alignment.topLeft, child: Text('Top Left')),
                    DropdownMenuItem(value: Alignment.topCenter, child: Text('Top Center')),
                    DropdownMenuItem(value: Alignment.topRight, child: Text('Top Right')),
                    DropdownMenuItem(value: Alignment.centerLeft, child: Text('Center Left')),
                    DropdownMenuItem(value: Alignment.center, child: Text('Center')),
                    DropdownMenuItem(value: Alignment.centerRight, child: Text('Center Right')),
                    DropdownMenuItem(value: Alignment.bottomLeft, child: Text('Bottom Left')),
                    DropdownMenuItem(value: Alignment.bottomCenter, child: Text('Bottom Center')),
                    DropdownMenuItem(value: Alignment.bottomRight, child: Text('Bottom Right')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _customAlignment = value);
                    }
                  },
                ),
              ],

              SwitchListTile(
                title: const Text('Use Margin'),
                subtitle: const Text('Add spacing around content'),
                value: _useMargin,
                onChanged: (value) => setState(() => _useMargin = value),
              ),

              if (_useMargin) ...[
                Text('Margin: ${_marginValue.round()}px'),
                Slider(
                  value: _marginValue,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  label: _marginValue.round().toString(),
                  onChanged: (value) => setState(() => _marginValue = value),
                ),
              ],

              SwitchListTile(
                title: const Text('Limit Width'),
                subtitle: const Text('Set maximum width constraint'),
                value: _useMaxWidth,
                onChanged: (value) => setState(() => _useMaxWidth = value),
              ),

              if (_useMaxWidth) ...[
                Text('Max Width: ${_maxWidth.round()}px'),
                Slider(
                  value: _maxWidth,
                  min: 200,
                  max: 600,
                  divisions: 20,
                  label: _maxWidth.round().toString(),
                  onChanged: (value) => setState(() => _maxWidth = value),
                ),
              ],

              SwitchListTile(
                title: const Text('Limit Height'),
                subtitle: const Text('Set maximum height constraint'),
                value: _useMaxHeight,
                onChanged: (value) => setState(() => _useMaxHeight = value),
              ),

              if (_useMaxHeight) ...[
                Text('Max Height: ${_maxHeight.round()}px'),
                Slider(
                  value: _maxHeight,
                  min: 100,
                  max: 400,
                  divisions: 15,
                  label: _maxHeight.round().toString(),
                  onChanged: (value) => setState(() => _maxHeight = value),
                ),
              ],

              const SizedBox(height: 24),

              // Auto-dismiss Features Section
              Text(
                'Auto-dismiss Features',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                title: const Text('Auto-hide on Progress Complete'),
                subtitle: const Text('Automatically hide when progress reaches 100%'),
                value: _autoHideOnComplete,
                onChanged: (value) => setState(() => _autoHideOnComplete = value),
              ),

              if (_autoHideOnComplete) ...[
                SwitchListTile(
                  title: const Text('Use Auto-hide Delay'),
                  subtitle: const Text('Add delay before hiding after completion'),
                  value: _useAutoHideDelay,
                  onChanged: (value) => setState(() => _useAutoHideDelay = value),
                ),
                if (_useAutoHideDelay) ...[
                  Text('Auto-hide Delay: ${_autoHideDelayValue.toStringAsFixed(1)}s'),
                  Slider(
                    value: _autoHideDelayValue,
                    min: 0.1,
                    max: 5.0,
                    divisions: 49,
                    label: '${_autoHideDelayValue.toStringAsFixed(1)}s',
                    onChanged: (value) => setState(() => _autoHideDelayValue = value),
                  ),
                ],
              ],

              SwitchListTile(
                title: const Text('Use Maximum Duration'),
                subtitle: const Text('Force hide after timeout (safety mechanism)'),
                value: _useMaxDuration,
                onChanged: (value) => setState(() => _useMaxDuration = value),
              ),

              if (_useMaxDuration) ...[
                Text('Max Duration: ${_maxDurationValue.round()}s'),
                Slider(
                  value: _maxDurationValue,
                  min: 5,
                  max: 120,
                  divisions: 23,
                  label: '${_maxDurationValue.round()}s',
                  onChanged: (value) => setState(() => _maxDurationValue = value),
                ),
              ],

              Divider(),

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
              ElevatedButton(
                onPressed: _autoDismissDemo,
                child: const Text('Auto-dismiss Demo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
