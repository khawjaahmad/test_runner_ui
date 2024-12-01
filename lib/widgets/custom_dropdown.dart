import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String hint;
  final String? label;
  final IconData? leadingIcon;
  final bool isRequired;
  final bool isEnabled;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.label,
    this.leadingIcon,
    this.isRequired = false,
    this.isEnabled = true,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  Color _getBorderColor(ThemeData theme) {
    if (!widget.isEnabled) {
      return theme.colorScheme.onSurface.withOpacity(0.12);
    }
    if (_isFocused) {
      return theme.colorScheme.primary;
    }
    if (_isHovered) {
      return theme.colorScheme.onSurface.withOpacity(0.38);
    }
    return theme.colorScheme.outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 14,
                    letterSpacing: 0.5,
                    color: widget.isEnabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withOpacity(0.38),
                  ),
                ),
                if (widget.isRequired)
                  Text(
                    ' *',
                    style: TextStyle(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Transform.scale(
            scale: 1.0, // Reduce entire dropdown by 10%
            alignment: Alignment.centerLeft,
            child: Focus(
              focusNode: _focusNode,
              child: DropdownButtonFormField<T>(
                value: widget.value,
                items: widget.items
                    .map((item) => DropdownMenuItem(
                          value: item.value,
                          child: SizedBox(
                            width: 290, // Increased to show full filename
                            child: Text(
                              item.child.toString(),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false, // Prevent wrapping to next line
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 14,
                                letterSpacing: 0.5,
                                color: widget.isEnabled
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurface.withOpacity(0.38),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: widget.isEnabled ? widget.onChanged : null,
                hint: Row(
                  children: [
                    if (widget.leadingIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          widget.leadingIcon,
                          color: widget.isEnabled
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.onSurface.withOpacity(0.38),
                        ),
                      ),
                    Text(
                      widget.hint,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        letterSpacing: 0.5,
                        color: widget.isEnabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface.withOpacity(0.38),
                      ),
                    ),
                  ],
                ),
                decoration: InputDecoration(
                  constraints: const BoxConstraints(
                    minWidth: 300, // Match main container
                    maxWidth: 340, // Match main container
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal:
                        12, // Slightly reduced to give more space for text
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _getBorderColor(theme),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _getBorderColor(theme),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colorScheme.onSurface.withOpacity(0.12),
                    ),
                  ),
                  filled: true,
                  fillColor: widget.isEnabled
                      ? colorScheme.surface
                      : colorScheme.onSurface.withOpacity(0.04),
                ),
                dropdownColor: colorScheme.surface,
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: widget.isEnabled
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface.withOpacity(0.38),
                ),
                iconSize: 24,
                isExpanded: true,
                menuMaxHeight: 300,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: widget.isEnabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withOpacity(0.38),
                ),
                itemHeight: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
