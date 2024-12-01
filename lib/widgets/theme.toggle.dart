import 'package:flutter/material.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const ThemeToggle({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isDark),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOutCubic,
        width: 56,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isDark 
              ? Colors.white.withOpacity(0.1) 
              : Colors.grey.withOpacity(0.3),
        ),
        padding: const EdgeInsets.all(2),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCirc,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.white : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 16,
                    color: isDark ? Colors.black : Colors.orange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}