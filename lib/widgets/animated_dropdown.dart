import 'package:flutter/material.dart';

/// @deprecated Use [CustomDropdown] instead.
/// This widget is maintained for backward compatibility and will be removed in a future version.
/// [CustomDropdown] provides more features and better customization options.
class AnimatedDropdown extends StatefulWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final String hint;
  final Function(String?) onChanged;
  final IconData icon;

  const AnimatedDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.icon,
  });

  @override
  State<AnimatedDropdown> createState() => _AnimatedDropdownState();
}

class _AnimatedDropdownState extends State<AnimatedDropdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    if (hovering) {
      _controller.forward();
    } else if (!hovering && widget.value == null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: Transform.scale(
          scale: 1.0, // Reduce entire dropdown by 10%
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _controller.value > 0
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Theme.of(context).colorScheme.outline.withOpacity(0.12),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    hoverColor: Colors.transparent,
                    popupMenuTheme: PopupMenuThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: widget.value,
                        items: widget.items.map((item) {
                          final text = item.child is Text
                              ? (item.child as Text).data ?? ''
                              : item.child.toString();
                          return DropdownMenuItem<String>(
                            value: item.value,
                            child: SizedBox(
                              width: 290, // Match CustomDropdown
                              child: Text(
                                text,
                                overflow: TextOverflow.ellipsis,
                                softWrap:
                                    false, // Prevent wrapping to next line
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              AnimatedBuilder(
                                animation: _rotateAnimation,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _rotateAnimation.value * 2 * 3.14,
                                    child: Icon(
                                      widget.icon,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.hint,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onChanged: (value) {
                          widget.onChanged(value);
                          if (value == null) {
                            _handleHover(false);
                          }
                        },
                        icon: RotationTransition(
                          turns: _rotateAnimation,
                          child: Icon(
                            Icons.expand_more_rounded,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                            size: 24,
                          ),
                        ),
                        isExpanded: true,
                        elevation: 8,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        dropdownColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.95),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                        menuMaxHeight: 300,
                        itemHeight: 48,
                        focusColor: Colors.transparent,
                        enableFeedback: true,
                        borderRadius: BorderRadius.circular(12),
                        alignment: AlignmentDirectional.centerStart,
                        isDense: false,
                        selectedItemBuilder: (BuildContext context) {
                          return widget.items.map<Widget>((item) {
                            return Container(
                              alignment: AlignmentDirectional.centerStart,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  AnimatedBuilder(
                                    animation: _rotateAnimation,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle:
                                            _rotateAnimation.value * 2 * 3.14,
                                        child: Icon(
                                          widget.icon,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 20,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.child is Text
                                          ? (item.child as Text).data ?? ''
                                          : item.child.toString(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: 14,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
