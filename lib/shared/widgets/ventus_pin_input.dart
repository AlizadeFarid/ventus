import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';

/// Segmented PIN entry, ported from the prototype `Controls.jsx` (PinInput).
///
/// Renders [length] boxes; typing advances focus, backspace on an empty box
/// retreats. Reports the assembled code via [onChanged] and fires [onCompleted]
/// when all digits are filled. Digits are masked with a dot when [masked].
class VentusPinInput extends StatefulWidget {
  const VentusPinInput({
    super.key,
    this.length = 4,
    this.masked = true,
    this.onChanged,
    this.onCompleted,
  });

  final int length;
  final bool masked;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<VentusPinInput> createState() => _VentusPinInputState();
}

class _VentusPinInputState extends State<VentusPinInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _value => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String raw) {
    final digit = raw.replaceAll(RegExp(r'\D'), '');
    if (digit.isEmpty) {
      _controllers[index].text = '';
    } else {
      // Keep only the last typed digit; advance focus.
      _controllers[index].text = digit.characters.last;
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    final value = _value;
    widget.onChanged?.call(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
    setState(() {});
  }

  KeyEventResult _onKey(int index, FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      widget.onChanged?.call(_value);
      setState(() {});
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (i) {
        final filled = _controllers[i].text.isNotEmpty;
        return Padding(
          padding: EdgeInsets.only(right: i == widget.length - 1 ? 0 : 12),
          child: SizedBox(
            width: 56,
            height: 64,
            child: Focus(
              onKeyEvent: (node, event) => _onKey(i, node, event),
              child: TextField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                obscureText: widget.masked,
                obscuringCharacter: '•',
                showCursor: true,
                cursorColor: colors.primary,
                maxLength: 1,
                onChanged: (v) => _onChanged(i, v),
                style: type.h1.copyWith(
                  fontSize: AppFontSize.h1,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  filled: true,
                  fillColor: filled ? colors.surface : colors.surfaceSand,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.brMd,
                    borderSide: filled
                        ? BorderSide(color: colors.primary, width: 1.5)
                        : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.brMd,
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
