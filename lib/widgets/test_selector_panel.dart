import 'package:flutter/material.dart';

class TestSelectorPanel extends StatelessWidget {
  final List<String> testFiles;
  final List<String> devices;
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;
  final VoidCallback onRunTests;
  final bool isDarkMode;

  const TestSelectorPanel({
    super.key,
    required this.testFiles,
    required this.devices,
    required this.selectedTags,
    required this.onTagsChanged,
    required this.onRunTests,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Test File Section
          Text(
            'Test File',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            items: testFiles.map((file) => DropdownMenuItem(
              value: file,
              child: Text(file),
            )).toList(),
            onChanged: (value) {},
          ),
          
          const SizedBox(height: 24),
          
          // Device Section
          Text(
            'Device',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            items: devices.map((device) => DropdownMenuItem(
              value: device,
              child: Text(device),
            )).toList(),
            onChanged: (value) {},
          ),
          
          const SizedBox(height: 24),
          
          // Tags Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Tags',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selectedTags.map((tag) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.label_outline, 
                              size: 16,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(tag),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Run Test Button
          Center(
            child: SizedBox(
              width: 160,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onRunTests,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  'Run Test',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}