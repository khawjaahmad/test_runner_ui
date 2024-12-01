import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';

class AppTheme {
  static const Duration themeDuration = Duration(milliseconds: 100);

  // Modern Color Palette
  static const vsBlue = Color(0xFF007ACC);
  static const vsLightBg = Color(0xFFFFFFFF);
  static const vsLightSidebar = Color(0xFFF5F5F5);
  static const vsLightText = Color(0xFF2C2C2C);
  static const vsDarkBg = Color(0xFF000000);
  static const vsDarkSidebar = Color(0xFF121212);
  static const vsDarkText = Color(0xFFE0E0E0);
  static const vsActiveElement = Color(0xFF1E1E1E);
  static const vsActiveLight = Color(0xFFE8E8E8);

  // Interactive States
  static const vsHoverLight = Color(0xFFE8E8E8);
  static const vsHoverDark = Color(0xFF2A2A2A);
  static const vsFocusLight = Color(0xFFD0D0D0);
  static const vsFocusDark = Color(0xFF3A3A3A);

  // Gradient Colors
  static const gradientStart = Color(0xFF3498DB);
  static const gradientEnd = Color(0xFF2980B9);

  // Card Colors
  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF2C2C2C);

  static final textTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
    ),
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    titleLarge: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    ),
    bodySmall: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4,
    ),
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    labelMedium: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
    ),
    labelSmall: GoogleFonts.montserrat(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: vsBlue,
    scaffoldBackgroundColor: vsLightBg,
    cardColor: cardLight,
    colorScheme: const ColorScheme.light(
      primary: vsBlue,
      secondary: gradientEnd,
      surface: vsLightSidebar,
      background: vsLightBg,
      onPrimary: vsLightBg,
      onSurface: vsLightText,
    ).copyWith(
      shadow: Colors.black.withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: vsBlue,
        foregroundColor: vsLightBg,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: textTheme.apply(
      bodyColor: vsLightText,
      displayColor: vsLightText,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: Colors.transparent,
        ),
        TargetPlatform.linux: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: Colors.transparent,
        ),
        TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: Colors.transparent,
        ),
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
      },
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      borderRadius: BorderRadius.circular(12),
      selectedBorderColor: Colors.transparent,
      borderColor: Colors.transparent,
      fillColor: Colors.blue.withOpacity(0.1),
      selectedColor: Colors.blue,
      color: Colors.grey,
      constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
    ),
    visualDensity: VisualDensity.standard,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: vsBlue,
    scaffoldBackgroundColor: vsDarkBg,
    cardColor: cardDark,
    colorScheme: const ColorScheme.dark(
      primary: vsBlue,
      secondary: gradientEnd,
      surface: vsDarkSidebar,
      background: vsDarkBg,
      onPrimary: vsDarkBg,
      onSurface: vsDarkText,
    ).copyWith(
      shadow: Colors.black.withOpacity(0.2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: vsBlue,
        foregroundColor: vsDarkText,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: textTheme.apply(
      bodyColor: vsDarkText,
      displayColor: vsDarkText,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      },
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      borderRadius: BorderRadius.circular(12),
      selectedBorderColor: Colors.transparent,
      borderColor: Colors.transparent,
      fillColor: Colors.blue.withOpacity(0.2),
      selectedColor: Colors.blue,
      color: Colors.grey,
      constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
    ),
    visualDensity: VisualDensity.standard,
  );
}

class AnimatedTagSelector extends StatefulWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;
  final bool isDarkMode;

  const AnimatedTagSelector({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagsChanged,
    required this.isDarkMode,
  });

  @override
  State<AnimatedTagSelector> createState() => _AnimatedTagSelectorState();
}

class _AnimatedTagSelectorState extends State<AnimatedTagSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.tags.map((tag) {
          final isSelected = widget.selectedTags.contains(tag);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
            child: InkWell(
              onTap: () {
                final newTags = List<String>.from(widget.selectedTags);
                if (isSelected) {
                  newTags.remove(tag);
                } else {
                  newTags.add(tag);
                }
                widget.onTagsChanged(newTags);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tag,
                      style: TextStyle(
                        color: isSelected ? Colors.white : null,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
