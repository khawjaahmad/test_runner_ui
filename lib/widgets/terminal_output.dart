import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class TerminalOutput extends StatefulWidget {
  final Stream<String>? outputStream;
  final double? height;
  final double? width;
  final Color backgroundColor;
  final Color textColor;

  const TerminalOutput({
    super.key,
    this.outputStream,
    this.height,
    this.width,
    this.backgroundColor = const Color(0xFF1E1E1E),
    this.textColor = Colors.white,
  });

  @override
  State<TerminalOutput> createState() => _TerminalOutputState();
}

class _TerminalOutputState extends State<TerminalOutput> {
  final ScrollController _scrollController = ScrollController();
  final List<TerminalLine> _lines = [];
  bool _autoScroll = true;

  @override
  void initState() {
    super.initState();
    // Add test text to verify font
    _lines.add(TerminalLine('''
FONT TEST (Compare these characters):
1. Zero vs O: 0O
2. Lowercase L vs One vs I: l1I
3. Arrows: -> => <- <=
4. Braces: {} [] ()
5. JetBrains specific ligatures: != => == === // /* */
--------------------------------'''));
    _setupOutputStream();
  }

  void _setupOutputStream() {
    widget.outputStream?.listen((data) {
      _processOutput(data);
    });
  }

  void _processOutput(String data) {
    final lines = const LineSplitter().convert(data);
    setState(() {
      for (var line in lines) {
        _lines.add(TerminalLine(line));
      }
    });

    if (_autoScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _clearTerminal() {
    setState(() {
      _lines.clear();
    });
  }

  void _copyToClipboard() {
    final text = _lines.map((line) => line.text).join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terminal output copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: _buildTerminalContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.backgroundColor.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              _autoScroll ? Icons.lock_outline : Icons.lock_open,
              color: widget.textColor.withOpacity(0.7),
              size: 16,
            ),
            onPressed: () {
              setState(() {
                _autoScroll = !_autoScroll;
              });
            },
            tooltip: 'Toggle auto-scroll',
          ),
          IconButton(
            icon: Icon(
              Icons.copy,
              color: widget.textColor.withOpacity(0.7),
              size: 16,
            ),
            onPressed: _copyToClipboard,
            tooltip: 'Copy to clipboard',
          ),
          IconButton(
            icon: Icon(
              Icons.clear,
              color: widget.textColor.withOpacity(0.7),
              size: 16,
            ),
            onPressed: _clearTerminal,
            tooltip: 'Clear terminal',
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalContent() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: double.infinity,
          child: MouseRegion(
            cursor: SystemMouseCursors.text,
            child: SelectableText.rich(
              TextSpan(
                style: TextStyle(
                  color: widget.textColor,
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  height: 1.5,
                ),
                children: _lines.map((line) {
                  return TextSpan(
                    children: [
                      line.processedText,
                      const TextSpan(text: '\n'),
                    ],
                  );
                }).toList(),
              ),
              textAlign: TextAlign.left,
              style: const TextStyle(
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class TerminalLine {
  final String text;
  final DateTime timestamp;
  final TextSpan processedText;

  TerminalLine(String rawText)
      : text = rawText,
        timestamp = DateTime.now(),
        processedText = _processAnsiCodes(rawText);

  static TextSpan _processAnsiCodes(String text) {
    // Handle cursor movement sequences first
    var processedText = text
        .replaceAll(RegExp(r'\x1B\[\d*A'), '') // Remove cursor up
        .replaceAll(RegExp(r'\x1B\[\d*B'), '') // Remove cursor down
        .replaceAll(RegExp(r'\x1B\[\d*C'), '') // Remove cursor forward
        .replaceAll(RegExp(r'\x1B\[\d*D'), '') // Remove cursor back
        .replaceAll(RegExp(r'\x1B\[K'), '') // Remove clear line
        .replaceAll(RegExp(r'\x1B\[2K'), '') // Remove clear entire line
        .replaceAll(RegExp(r'\x1B\[s'), '') // Remove save cursor position
        .replaceAll(RegExp(r'\x1B\[u'), ''); // Remove restore cursor position

    // Handle color and style sequences
    processedText = processedText
        .replaceAll(RegExp(r'\x1B\[\d+;\d+;\d+m'), '') // RGB color codes
        .replaceAll(RegExp(r'\x1B\[\d+m'), '') // Simple color codes
        .replaceAll(RegExp(r'\x1B\[0m'), ''); // Reset formatting

    return TextSpan(text: processedText);
  }
}
