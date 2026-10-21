import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_search_field.dart';
import '../../core/theme/app_spacing.dart';

/// Inline search: a [VentusSearchField] pinned above [child]. Tapping the
/// field just focuses it (no sheet, no jump); while it has focus the results
/// from [resultsBuilder] take over the whole area below it, and the field's
/// search glyph turns into a back arrow that hands the screen back.
///
/// [resultsBuilder] receives the current query and a `close` callback to call
/// once the user has picked something.
class VentusSearchLayout extends StatefulWidget {
  const VentusSearchLayout({
    super.key,
    required this.hintText,
    required this.resultsBuilder,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      0,
      AppSpacing.screen,
      12,
    ),
  });

  final String hintText;
  final Widget Function(BuildContext context, String query, VoidCallback close)
  resultsBuilder;

  /// The screen content shown while the search is idle.
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  State<VentusSearchLayout> createState() => _VentusSearchLayoutState();
}

class _VentusSearchLayoutState extends State<VentusSearchLayout> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _active = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (_focus.hasFocus && !_active) setState(() => _active = true);
  }

  void _close() {
    _focus.unfocus();
    _controller.clear();
    setState(() {
      _active = false;
      _query = '';
    });
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: widget.padding,
          child: VentusSearchField(
            controller: _controller,
            focusNode: _focus,
            hintText: widget.hintText,
            onChanged: (v) => setState(() => _query = v),
            onBack: _active ? _close : null,
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: _active
                ? ColoredBox(
                    key: const ValueKey('results'),
                    color: colors.bg,
                    child: SizedBox.expand(
                      child: widget.resultsBuilder(context, _query, _close),
                    ),
                  )
                : KeyedSubtree(
                    key: const ValueKey('content'),
                    child: widget.child,
                  ),
          ),
        ),
      ],
    );
  }
}
