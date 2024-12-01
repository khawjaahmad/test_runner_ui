import 'package:flutter/material.dart';

class TestCommandViewer extends StatefulWidget {
  final String targetTest;
  final List<String> tags;
  final String deviceId;
  final bool isIOS;

  const TestCommandViewer({
    super.key,
    required this.targetTest,
    required this.tags,
    required this.deviceId,
    required this.isIOS,
  });

  @override
  State<TestCommandViewer> createState() => _TestCommandViewerState();
}

class _TestCommandViewerState extends State<TestCommandViewer> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Test Configuration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Test File:', widget.targetTest),
            const SizedBox(height: 8),
            _buildInfoRow('Device:', widget.deviceId),
            const SizedBox(height: 8),
            _buildInfoRow(
                'Tags:', widget.tags.isEmpty ? 'None' : widget.tags.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
