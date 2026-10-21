import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Font sizes come from `AppFontSize` / `AppTypography`; a numeric literal in
/// `fontSize:` anywhere else means a screen drifted off the shared type scale.
void main() {
  test('no numeric fontSize literals outside app_typography.dart', () {
    final literal = RegExp(r'fontSize:\s*\d');
    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.path.endsWith('app_typography.dart')) continue;
      final lines = entity.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (literal.hasMatch(lines[i])) {
          offenders.add('${entity.path}:${i + 1}');
        }
      }
    }
    expect(offenders, isEmpty);
  });
}
