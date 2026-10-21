import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/ventus_controls.dart';
import '../../../../shared/widgets/ventus_icon.dart';
import '../../domain/document_type.dart';

/// The thumbnail / row icon for a document type (prototype `Documents.jsx`).
String documentTypeIcon(DocumentType type) => switch (type) {
  DocumentType.ticket => VentusIcons.ticket,
  DocumentType.stay => VentusIcons.bed,
  DocumentType.id => VentusIcons.user,
  DocumentType.other => VentusIcons.document,
};

/// The badge tone for a document type's tag pill.
VentusBadgeTone documentTypeBadgeTone(DocumentType type) => switch (type) {
  DocumentType.ticket => VentusBadgeTone.sea,
  DocumentType.stay => VentusBadgeTone.primary,
  DocumentType.id => VentusBadgeTone.neutral,
  DocumentType.other => VentusBadgeTone.amber,
};

/// Foreground + soft background colors for the colored document thumbnail.
({Color fg, Color soft}) documentTypeThumbColors(
  DocumentType type,
  AppColors colors,
) => switch (type) {
  DocumentType.ticket => (fg: colors.sea, soft: colors.seaSoft),
  DocumentType.stay => (fg: colors.primary, soft: colors.primarySoft),
  DocumentType.id => (fg: colors.ink2, soft: colors.surfaceSand),
  DocumentType.other => (fg: colors.amber, soft: colors.amberSoft),
};

/// Localized singular type name (Ticket / Stay / ID / Other).
String documentTypeLabel(AppLocalizations l10n, DocumentType type) =>
    switch (type) {
      DocumentType.ticket => l10n.docTypeTicket,
      DocumentType.stay => l10n.docTypeStay,
      DocumentType.id => l10n.docTypeId,
      DocumentType.other => l10n.docTypeOther,
    };

/// Human-readable file size (e.g. `0.4 MB`, `12 KB`), or empty when unknown.
String formatFileSize(int? bytes) {
  if (bytes == null || bytes <= 0) return '';
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(1)} MB';
  if (bytes >= kb) return '${(bytes / kb).round()} KB';
  return '$bytes B';
}
