import 'package:flutter/material.dart';
import '../theme/app_theme.dart' as theme;

class TestTagsSelector extends StatefulWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;
  final bool isDarkMode;

  const TestTagsSelector({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagsChanged,
    required this.isDarkMode,
  });

  @override
  State<TestTagsSelector> createState() => _TestTagsSelectorState();
}

class _TestTagsSelectorState extends State<TestTagsSelector> {
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _tagsScrollController = ScrollController();

  @override
  void dispose() {
    _mainScrollController.dispose();
    _tagsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 280,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? theme.AppTheme.vsDarkBg.withOpacity(0.3)
            : theme.AppTheme.vsLightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: RawScrollbar(
        controller: _mainScrollController,
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(3),
        thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        minThumbLength: 48,
        padding: const EdgeInsets.only(right: 2),
        child: SingleChildScrollView(
          controller: _mainScrollController,
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.selectedTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => widget.onTagsChanged([]),
                        icon: const Icon(
                          Icons.restart_alt_rounded,
                          size: 16,
                          color: Colors.blue,
                        ),
                        tooltip: 'Reset tags',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 16,
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      margin: const EdgeInsets.only(top: 2),
                      child: RawScrollbar(
                        controller: _tagsScrollController,
                        thumbVisibility: true,
                        thickness: 6,
                        radius: const Radius.circular(3),
                        thumbColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        minThumbLength: 48,
                        padding: const EdgeInsets.only(right: 2),
                        child: SingleChildScrollView(
                          controller: _tagsScrollController,
                          padding: const EdgeInsets.only(right: 12),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: widget.availableTags.map((tag) {
                                final isSelected =
                                    widget.selectedTags.contains(tag);
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      final newTags = List<String>.from(
                                          widget.selectedTags);
                                      if (!isSelected) {
                                        newTags.add(tag);
                                      } else {
                                        newTags.remove(tag);
                                      }
                                      widget.onTagsChanged(newTags);
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 200, // Fixed width for all tags
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primaryContainer
                                            : widget.isDarkMode
                                                ? Colors.grey[850]
                                                    ?.withOpacity(0.5)
                                                : Colors.grey[100]
                                                    ?.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.5)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline
                                                  .withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isSelected
                                                ? Icons.local_offer
                                                : Icons.local_offer_outlined,
                                            size: 16,
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              tag,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimaryContainer
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withOpacity(0.8),
                                                fontSize: 14,
                                                height: 1.2,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
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
}
