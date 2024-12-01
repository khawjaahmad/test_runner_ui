import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_runner_ui/constants/assets.dart';
import 'theme/app_theme.dart' as theme;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'widgets/theme.toggle.dart';
import 'widgets/animated_dropdown.dart';
import 'widgets/buttons.dart';
import 'widgets/tags_selector.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform, Process;
import 'dart:convert' show utf8;
import 'widgets/terminal_output.dart';
import 'widgets/test_command_viewer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window manager
  await windowManager.ensureInitialized();

  // Configure window options
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(800, 600), // Set minimum window size
    size: Size(1024, 768), // Set initial window size
    center: true, // Center window on screen
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  // Apply window options and show window
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const TestRunnerApp());
}

class TestRunnerApp extends StatefulWidget {
  const TestRunnerApp({super.key});

  @override
  State<TestRunnerApp> createState() => _TestRunnerAppState();
}

class _TestRunnerAppState extends State<TestRunnerApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PatrolX',
      theme: theme.AppTheme.lightTheme,
      darkTheme: theme.AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      themeAnimationDuration: theme.AppTheme.themeDuration,
      themeAnimationCurve: Curves.easeInOutCubic,
      debugShowCheckedModeBanner: false,
      home: AnimatedContainer(
        duration: theme.AppTheme.themeDuration,
        curve: Curves.easeInOutCubic,
        color: isDarkMode ? theme.AppTheme.vsDarkBg : theme.AppTheme.vsLightBg,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 64,
            elevation: 0,
            backgroundColor: isDarkMode
                ? theme.AppTheme.vsDarkSidebar
                : theme.AppTheme.vsLightSidebar,
            title: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerLeft,
                      colors: isDarkMode
                          ? [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05)
                            ]
                          : [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.02)
                            ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      isDarkMode
                          ? AppAssets.flutterLogoLight
                          : AppAssets.flutterLogoDark,
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                      colorFilter: isDarkMode
                          ? const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn)
                          : null,
                    ),
                  ),
                ),
                const Spacer(),
                ThemeToggle(
                  isDark: isDarkMode,
                  onChanged: (darkMode) {
                    setState(() {
                      isDarkMode = darkMode;
                    });
                  },
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          body: TestRunnerScreen(
            onThemeToggle: toggleTheme,
            isDarkMode: isDarkMode,
          ),
        ),
      ),
    );
  }
}

class TestRunnerScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const TestRunnerScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen> {
  bool isLoading = false;
  String? selectedTest;
  String? selectedDevice;
  List<String> selectedTags = [];
  String selectedOperator = '&&'; // Default to AND
  final _terminalController = StreamController<String>.broadcast();
  bool testCompleted = false;
  bool testSuccess = false;

  static const devices = {
    'emulator-5554': 'Android',
    '358D68E0-18EE-4E8F-A266-5D8575A1F113': 'iPhone',
  };

  bool get canRun => selectedTest != null && selectedDevice != null;

  String _formatTags(List<String> tags, String operator) {
    if (tags.isEmpty) return '';
    if (tags.length == 1) return tags.first;
    return tags.join(' $operator ');
  }

  Future<void> _runTest() async {
    if (!canRun) return;

    setState(() {
      isLoading = true;
      testCompleted = false;
      testSuccess = false;
    });

    try {
      if (!Platform.isMacOS) {
        _terminalController
            .add('Error: Tests can only be run from macOS desktop app.\n');
        return;
      }

      final formattedTags = _formatTags(selectedTags, selectedOperator);

      // Debug logging
      _terminalController.add('Selected Tags: $selectedTags\n');
      _terminalController.add('Selected Operator: $selectedOperator\n');
      _terminalController.add('Formatted Tags: $formattedTags\n');

      // Construct the full command as a single string
      final fullCommand = './integration_test/scripts/patrol_runner.sh test '
          '--target integration_test/tests/$selectedTest '
          '--tags=$formattedTags '
          '--device=$selectedDevice';

      // Debug logging
      _terminalController.add('Executing command: $fullCommand\n');

      final process = await Process.start(
        'bash',
        ['-c', fullCommand],
        workingDirectory: '/Users/ahmadwaqar/IdeaProjects/mobile-buyer',
        runInShell: true,
        environment: {
          'PATH': Platform.environment['PATH'] ?? '',
          'HOME': Platform.environment['HOME'] ?? '',
        },
      );

      // Display output in real-time
      process.stdout.transform(utf8.decoder).listen((data) {
        _terminalController.add(data);
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        _terminalController.add(data);
      });

      final exitCode = await process.exitCode;
      _terminalController.add('Process exit code: $exitCode\n');

      setState(() {
        testCompleted = true;
        testSuccess = exitCode == 0;
      });
    } catch (e) {
      _terminalController.add('Error: $e\n');
      setState(() {
        testCompleted = true;
        testSuccess = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 0.9, // Reduce entire container by 10%
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? theme.AppTheme.vsBlue.withOpacity(0.15)
                  : theme.AppTheme.vsBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  title.contains('Test')
                      ? Icons.integration_instructions_rounded
                      : Icons.devices_rounded,
                  size: 18,
                  color: theme.AppTheme.vsBlue,
                ),
                const SizedBox(width: 10),
                Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: theme.AppTheme.vsBlue,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
            height: 6), // Reduced from 8 to account for Transform.scale
      ],
    );
  }

  Widget _buildControlPanel() {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 340,
        minHeight: 100,
      ),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? theme.AppTheme.vsDarkSidebar
            : theme.AppTheme.vsLightSidebar,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? Colors.white.withOpacity(0.03)
                      : Colors.black.withOpacity(0.02),
                  border: Border(
                    bottom: BorderSide(
                      color: widget.isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Test Configuration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Test File Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('Test File'),
                            if (selectedTest != null)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedTest = null;
                                    selectedDevice = null;
                                    selectedTags.clear();
                                  });
                                },
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 18,
                                ),
                                tooltip: 'Reset all fields',
                                style: IconButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  minimumSize: const Size(36, 36),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        AnimatedDropdown(
                          value: selectedTest,
                          items: [
                            'loginpage_phone_test.dart',
                            'register_page_phone_test.dart',
                          ]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          hint: 'Select test file',
                          icon: Icons.code,
                          onChanged: (value) {
                            setState(() {
                              selectedTest = value;
                              selectedTags.clear();
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Device Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Device'),
                        const SizedBox(height: 8),
                        AnimatedDropdown(
                          value: selectedDevice,
                          items: devices.entries
                              .map((e) => DropdownMenuItem(
                                    value: e.key,
                                    child: Text(e.value),
                                  ))
                              .toList(),
                          hint: 'Select device',
                          icon: Icons.devices,
                          onChanged: (value) {
                            setState(() {
                              selectedDevice = value;
                            });
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Tags Selection
                    if (selectedTest != null) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Tags'),
                          const SizedBox(height: 12),
                          TestTagsSelector(
                            availableTags:
                                selectedTest == 'loginpage_phone_test.dart'
                                    ? [
                                        'welcome_permissions',
                                        'welcome_screen',
                                        'welcome_language',
                                        'login_screen_elements',
                                        'login_overlay',
                                        'phone_login',
                                        'phone_login_e2e',
                                      ]
                                    : [
                                        'register_welcome_permissions',
                                        'register_welcome_screen',
                                        'register_welcome_language',
                                        'register_e2e',
                                      ],
                            selectedTags: selectedTags,
                            onTagsChanged: (tags) {
                              setState(() {
                                selectedTags = tags;
                              });
                            },
                            isDarkMode: widget.isDarkMode,
                          ),
                          if (selectedTags.length >= 2) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text('Combine tags with: '),
                                SegmentedButton<String>(
                                  segments: const [
                                    ButtonSegment<String>(
                                      value: '&&',
                                      label: Text('AND'),
                                    ),
                                    ButtonSegment<String>(
                                      value: '||',
                                      label: Text('OR'),
                                    ),
                                  ],
                                  selected: {selectedOperator},
                                  onSelectionChanged:
                                      (Set<String> newSelection) {
                                    setState(() {
                                      selectedOperator = newSelection.first;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Command Preview
                            TestCommandViewer(
                              targetTest:
                                  'integration_test/tests/$selectedTest',
                              tags: selectedTags,
                              deviceId: selectedDevice ?? '',
                              isIOS: selectedDevice ==
                                  '358D68E0-18EE-4E8F-A266-5D8575A1F113',
                            ),
                          ],
                        ],
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Run Button
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: canRun && !isLoading ? _runTest : null,
                            icon: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.play_arrow_rounded),
                            label: Text(isLoading ? 'Running...' : 'Run Test'),
                          ),
                        ),
                        if (canRun) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              final formattedTags =
                                  _formatTags(selectedTags, selectedOperator);
                              const commandPrefix =
                                  './integration_test/scripts/patrol_runner.sh test --target integration_test/tests/';
                              final command = '$commandPrefix$selectedTest '
                                  '--tags=$formattedTags '
                                  '--device=$selectedDevice';

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Preview Command:',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.copy_rounded,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                            onPressed: () {
                                              Clipboard.setData(
                                                  ClipboardData(text: command));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                      'Command copied to clipboard'),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                ),
                                              );
                                            },
                                            tooltip: 'Copy to clipboard',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        command,
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            },
                            icon: const Icon(Icons.preview_outlined),
                            tooltip: 'Preview command',
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutputPanel(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? theme.AppTheme.vsDarkSidebar
            : theme.AppTheme.vsLightSidebar,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Terminal Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? theme.AppTheme.vsActiveElement
                  : Colors.grey[100],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(
                    Icons.terminal,
                    size: 18,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Terminal Output',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Terminal Content
          Expanded(
            child: TerminalOutput(
              outputStream: _terminalController.stream,
              backgroundColor: isDarkMode
                  ? theme.AppTheme.vsDarkSidebar
                  : theme.AppTheme.vsLightSidebar,
              textColor: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _terminalController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          // Make the main Row responsive
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Switch to Column layout if width is too small
              if (constraints.maxWidth < 700) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildControlPanel(),
                      const SizedBox(height: 24),
                      _buildOutputPanel(isDarkMode),
                    ],
                  ),
                );
              }

              // Regular Row layout for wider screens
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Panel with fixed width but can shrink
                  Flexible(
                    flex: 2,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: _buildControlPanel(),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Right Panel that takes remaining space
                  Flexible(
                    flex: 3,
                    child: _buildOutputPanel(isDarkMode),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
