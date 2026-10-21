import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../shared/widgets/ventus_icon.dart';
import '../../domain/document_type.dart';
import 'document_format.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// The little colored "document" tile — a soft tinted card with a top accent
/// bar, the type icon and an extension label (prototype `Documents.jsx` →
/// DocThumb). Used in the documents list, the upload sheet and the detail.
class DocThumb extends StatelessWidget {
  const DocThumb({super.key, required this.type, this.ext, this.size = 46});

  final DocumentType type;
  final String? ext;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = documentTypeThumbColors(type, colors);

    return Container(
      width: size,
      height: size * 1.18,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: tone.soft, borderRadius: AppRadius.brSm),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(height: 5, color: tone.fg.withValues(alpha: 0.85)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VentusIcon(
                  documentTypeIcon(type),
                  size: size * 0.42,
                  color: tone.fg,
                ),
                if (ext != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    ext!,
                    style: TextStyle(
                      fontSize: AppFontSize.eyebrow,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: tone.fg.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
