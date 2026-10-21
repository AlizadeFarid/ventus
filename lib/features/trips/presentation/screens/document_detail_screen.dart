import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/documents_controller.dart';
import '../../application/documents_providers.dart';
import '../../application/trip_detail_providers.dart';
import '../../domain/document.dart';
import '../widgets/doc_thumb.dart';
import '../widgets/document_format.dart';
import 'documents_screen.dart' show showEditDocumentSheet;
import 'itinerary_screen.dart' show dayDate;
import 'trip_detail_screen.dart' show HubTab;
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Full-screen document detail / preview (prototype `Documents.jsx` →
/// DocumentDetail): an inline image (or a file placeholder), the linked day,
/// and Share / Save / Edit / Delete actions.
class DocumentDetailScreen extends ConsumerWidget {
  const DocumentDetailScreen({
    super.key,
    required this.tripId,
    required this.docId,
  });

  final String tripId;
  final String docId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final docs =
        ref.watch(documentsProvider(tripId)).asData?.value ??
        const <TripDocument>[];
    final doc = docs.where((d) => d.id == docId).firstOrNull;

    if (doc == null) {
      return Scaffold(
        backgroundColor: colors.bg,
        appBar: VentusAppBar(title: context.l10n.moduleDocuments),
        body: Center(
          child: Text(
            context.l10n.tripNotFound,
            style: context.typography.body.copyWith(color: colors.muted),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.surfaceSand,
      body: Column(
        children: [
          _Header(doc: doc),
          Expanded(child: _Preview(doc: doc)),
          _ActionsBar(tripId: tripId, doc: doc),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.doc});

  final TripDocument doc;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final lang = context.languageCode;
    final added = DateFormat.MMMd(lang).format(doc.createdAt);
    final meta = [
      if (doc.ext != null) doc.ext!,
      if (formatFileSize(doc.sizeBytes).isNotEmpty)
        formatFileSize(doc.sizeBytes),
      added,
    ].join(' · ');

    return SafeArea(
      bottom: false,
      child: Container(
        color: colors.bg,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          6,
          AppSpacing.screen,
          12,
        ),
        child: Row(
          children: [
            VentusTap(
              onTap: () => _leave(context),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  boxShadow: context.shadows.card,
                ),
                child: VentusIcon(
                  VentusIcons.arrowLeft,
                  size: 20,
                  color: colors.ink,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w700,
                      color: colors.ink,
                    ),
                  ),
                  Text(
                    meta,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            VentusBadge(
              label: documentTypeLabel(context.l10n, doc.type),
              tone: documentTypeBadgeTone(doc.type),
            ),
          ],
        ),
      ),
    );
  }

  void _leave(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }
}

class _Preview extends ConsumerWidget {
  const _Preview({required this.doc});

  final TripDocument doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        18,
        AppSpacing.screen,
        18,
      ),
      children: [
        doc.isImage ? _ImagePreview(doc: doc) : _FilePreview(doc: doc),
        if (doc.day != null) ...[
          const SizedBox(height: 16),
          _LinkedDayPill(doc: doc),
        ],
      ],
    );
  }
}

class _ImagePreview extends ConsumerWidget {
  const _ImagePreview({required this.doc});

  final TripDocument doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final urlAsync = ref.watch(documentSignedUrlProvider(doc));
    return ClipRRect(
      borderRadius: AppRadius.brLg,
      child: Container(
        color: colors.surface,
        constraints: const BoxConstraints(minHeight: 240),
        alignment: Alignment.center,
        child: urlAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(40),
            child: VentusSpinner(),
          ),
          error: (_, _) =>
              _PreviewMessage(text: context.l10n.previewUnavailable),
          data: (url) => url == null
              ? _PreviewMessage(text: context.l10n.connectToView)
              : CachedNetworkImage(
                  imageUrl: url,
                  // Signed URLs carry a fresh, expiring token every time, so
                  // keying the cache on the URL would store the same file over
                  // and over. The storage path is stable — key on that.
                  cacheKey: doc.storagePath,
                  fit: BoxFit.contain,
                  progressIndicatorBuilder: (_, _, _) => const Padding(
                    padding: EdgeInsets.all(40),
                    child: VentusSpinner(),
                  ),
                  errorWidget: (context, _, _) =>
                      _PreviewMessage(text: context.l10n.previewUnavailable),
                ),
        ),
      ),
    );
  }
}

/// Placeholder card for non-image files (PDFs, etc.) with an "Open" button.
class _FilePreview extends ConsumerWidget {
  const _FilePreview({required this.doc});

  final TripDocument doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 36,
        horizontal: AppSpacing.screen,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Column(
        children: [
          DocThumb(type: doc.type, ext: doc.ext, size: 84),
          const SizedBox(height: 18),
          Text(
            doc.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSize.body,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 18),
          VentusButton(
            label: context.l10n.openFile,
            iconLeft: VentusIcons.eye,
            variant: VentusButtonVariant.secondary,
            onPressed: () => openDocument(context, ref, doc),
          ),
        ],
      ),
    );
  }
}

class _PreviewMessage extends StatelessWidget {
  const _PreviewMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.typography.body.copyWith(color: context.colors.muted),
      ),
    );
  }
}

class _LinkedDayPill extends StatelessWidget {
  const _LinkedDayPill({required this.doc});

  final TripDocument doc;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final lang = context.languageCode;
    // Resolve the day's date through the trip (read via the widget tree's ref).
    return Consumer(
      builder: (context, ref, _) {
        final t = ref.watch(tripDetailProvider(doc.tripId)).asData?.value;
        final date = dayDate(t, doc.day!);
        final dayStr = date == null
            ? l10n.docDayShort(doc.day!)
            : l10n.docDayWithDate(
                doc.day!,
                DateFormat.MMMMEEEEd(lang).format(date),
              );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.brMd,
            boxShadow: context.shadows.card,
          ),
          child: Row(
            children: [
              VentusIcon(VentusIcons.calendar, size: 17, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.documentLinkedTo(dayStr),
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w600,
                    color: colors.ink2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionsBar extends ConsumerWidget {
  const _ActionsBar({required this.tripId, required this.doc});

  final String tripId;
  final TripDocument doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: colors.bg,
        boxShadow: context.shadows.bar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
          child: Row(
            children: [
              _DetailAction(
                icon: VentusIcons.share,
                label: l10n.docActionShare,
                onTap: () => _share(context, ref),
              ),
              _DetailAction(
                icon: VentusIcons.download,
                label: l10n.docActionSave,
                onTap: () => openDocument(context, ref, doc),
              ),
              _DetailAction(
                icon: VentusIcons.edit,
                label: l10n.docActionEdit,
                onTap: () => _edit(context, ref),
              ),
              _DetailAction(
                icon: VentusIcons.trash,
                label: l10n.docActionDelete,
                danger: true,
                onTap: () => _delete(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final failed = context.l10n.somethingWentWrong;
    final file = await _materialize(ref, doc);
    if (file == null) {
      if (!context.mounted) return;
      showVentusError(context, failed);
      return;
    }
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: doc.mimeType)]),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final trip = ref.read(tripDetailProvider(tripId)).asData?.value;
    await showEditDocumentSheet(context, tripId: tripId, trip: trip, doc: doc);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await confirmVentusAction(
      context,
      title: l10n.deleteDocumentTitle,
      body: l10n.deleteDocumentBody,
      confirmLabel: l10n.deleteConfirm,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final router = GoRouter.of(context);
    final deleted = l10n.documentDeleted;
    final failed = l10n.somethingWentWrong;
    final ok = await ref.read(documentsControllerProvider.notifier).delete(doc);
    if (!context.mounted) return;
    if (ok) {
      showVentusSuccess(context, deleted);
    } else {
      showVentusError(context, failed);
    }
    if (ok) {
      router.go(AppRoutes.tripDetail(tripId), extra: HubTab.documents);
    }
  }
}

/// Downloads the file to a temp path and opens it with the OS viewer.
Future<void> openDocument(
  BuildContext context,
  WidgetRef ref,
  TripDocument doc,
) async {
  final failed = context.l10n.somethingWentWrong;
  final file = await _materialize(ref, doc);
  if (file == null) {
    if (!context.mounted) return;
    showVentusError(context, failed);
    return;
  }
  await OpenFilex.open(file.path);
}

/// Downloads a document's bytes into a temp file with a friendly name.
Future<File?> _materialize(WidgetRef ref, TripDocument doc) async {
  final bytes = await ref.read(documentsRepositoryProvider).fileBytes(doc);
  if (bytes == null) return null;
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/${_safeFileName(doc)}');
  await file.writeAsBytes(bytes);
  return file;
}

String _safeFileName(TripDocument doc) {
  var name = doc.name.replaceAll(RegExp(r'[/\\]'), '_');
  final ext = doc.ext?.toLowerCase();
  if (ext != null && !name.toLowerCase().endsWith('.$ext')) {
    name = '$name.$ext';
  }
  return name.isEmpty ? doc.id : name;
}

class _DetailAction extends StatelessWidget {
  const _DetailAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = danger ? colors.danger : colors.ink2;
    return Expanded(
      child: VentusTap(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: danger ? colors.dangerSoft : colors.surfaceSand,
                  borderRadius: AppRadius.brSm,
                ),
                child: VentusIcon(icon, size: 21, color: fg),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSize.caption,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
