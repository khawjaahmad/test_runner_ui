import 'package:flutter/material.dart';

class RunTestButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const RunTestButton({
    super.key,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedScale(
        scale: isLoading ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: FilledButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.play_arrow, size: 20),
          label: Text(
            isLoading ? 'Running...' : 'Run Test',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const ResetButton({
    super.key,
    required this.onPressed,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.all(4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Theme.of(context).colorScheme.error,
        disabledForegroundColor: Theme.of(context).colorScheme.error.withOpacity(0.5),
      ),
      child: const Text('Reset', style: TextStyle(fontSize: 12)),
    );
  }
}
