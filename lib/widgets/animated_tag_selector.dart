import 'package:flutter/material.dart';

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

class _AnimatedTagSelectorState extends State<AnimatedTagSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTagSelection(String tag) {
    final newTags = List<String>.from(widget.selectedTags);
    if (widget.selectedTags.contains(tag)) {
      newTags.remove(tag);
      _controller.reverse();
    } else {
      newTags.add(tag);
      _controller.forward();
    }
    widget.onTagsChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isLight = !widget.isDarkMode;

    final tagTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isLight ? colorScheme.onPrimary : colorScheme.onSurface,
      fontWeight: FontWeight.w500,
      fontSize: 14, // Added consistent font size
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional title
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Select Tags',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14, // Added consistent font size
              ),
            ),
          ),
          // Tags section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.tags.map((tag) {
                final isSelected = widget.selectedTags.contains(tag);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.identity()
                      ..scale(isSelected ? 1.05 : 1.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleTagSelection(tag),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          colorScheme.primary.withOpacity(0.3),
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
                                isSelected ? Icons.label : Icons.label_outline,
                                size: 16,
                                color: isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tag,
                                style: tagTextStyle?.copyWith(
                                  color: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.primary,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 4),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => _handleTagSelection(tag),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
