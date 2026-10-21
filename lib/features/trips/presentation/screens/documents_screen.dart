import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/documents_controller.dart';
import '../../application/documents_providers.dart';
import '../../application/trip_detail_providers.dart';
import '../../data/document_picker.dart';
import '../../domain/document.dart';
import '../../domain/document_type.dart';
import '../../domain/trip.dart';
import '../widgets/doc_thumb.dart';
import '../widgets/document_format.dart';
import 'itinerary_screen.dart' show dayDate;
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Opens the edit sheet for [doc] (type / linked day / name). Shared so the
/// document detail screen can reuse the same sheet as the list.
Future<void> showEditDocumentSheet(
  BuildContext context, {
  required String tripId,
  required Trip? trip,
  required TripDocument doc,
}) {
  return showVentusSheet<void>(
    context,
    builder: (_) => _DocumentSheet(tripId: tripId, trip: trip, existing: doc),
  );
}

/// Documents tab content — grouped, filterable list of a trip's uploaded
/// files with an upload flow (source → assign type & day). Embedded as the
/// Trip Hub's "Sənədlər" tab.
class DocumentsBody extends ConsumerStatefulWidget {
  const DocumentsBody({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<DocumentsBody> createState() => _DocumentsBodyState();
}

class _DocumentsBodyState extends ConsumerState<DocumentsBody> {
  @override
  Widget build(BuildContext context) {
    // Pull remote document metadata into Drift once for this trip.
    ref.watch(documentsSyncProvider(widget.tripId));
    final trip = ref.watch(tripDetailProvider(widget.tripId)).asData?.value;
    final docs =
        ref.watch(documentsProvider(widget.tripId)).asData?.value ??
        const <TripDocument>[];
    final colors = context.colors;
    final l10n = context.l10n;

    if (docs.isEmpty) {
      return _EmptyDocuments(onUpload: () => _startUpload(trip));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The tab already says "Documents", so the header row is the summary
        // plus the one add button (same pattern as the other tabs).
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            14,
            AppSpacing.screen,
            8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.documentsCount(docs.length),
                  style: context.typography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
              ),
              VentusAddButton(
                semanticLabel: l10n.uploadDocument,
                onTap: () => _startUpload(trip),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 24),
            children: _byType(docs),
          ),
        ),
      ],
    );
  }

  List<Widget> _byType(List<TripDocument> docs) {
    final l10n = context.l10n;
    final groups = <(String, List<TripDocument>)>[
      (l10n.docGroupTickets, _ofType(docs, DocumentType.ticket)),
      (l10n.docGroupStays, _ofType(docs, DocumentType.stay)),
      (l10n.docGroupIdentity, _ofType(docs, DocumentType.id)),
      (l10n.docGroupOther, _ofType(docs, DocumentType.other)),
    ];
    return [
      for (final (title, items) in groups)
        if (items.isNotEmpty)
          _GroupBlock(
            title: title,
            docs: items,
            subFor: (d) => _dayShort(d),
            onOpen: _openDetail,
            onMore: (d) => _openSheet(existing: d),
          ),
    ];
  }

  List<TripDocument> _ofType(List<TripDocument> docs, DocumentType t) =>
      docs.where((d) => d.type == t).toList();

  String? _dayShort(TripDocument d) =>
      d.day == null ? null : context.l10n.docDayShort(d.day!);

  void _openDetail(TripDocument d) =>
      context.push(AppRoutes.documentDetail(widget.tripId, d.id));

  /// Upload: pick a source, then the file, then assign its type & day.
  Future<void> _startUpload(Trip? trip) async {
    final source = await showVentusSheet<_DocSource>(
      context,
      builder: (_) => const _SourceSheet(),
    );
    if (source == null || !mounted) return;

    final failed = context.l10n.somethingWentWrong;
    PickedDocument? picked;
    try {
      picked = switch (source) {
        _DocSource.files => await DocumentPicker.pickFile(),
        _DocSource.camera => await DocumentPicker.pickFromCamera(),
        _DocSource.photos => await DocumentPicker.pickFromGallery(),
      };
    } catch (_) {
      // e.g. permission denied, or the native picker plugin isn't registered
      // (needs a full app rebuild after adding the plugin).
      if (!mounted) return;
      showVentusError(context, failed);
      return;
    }
    if (picked == null || !mounted) return;
    _openSheet(picked: picked, trip: trip);
  }

  void _openSheet({
    PickedDocument? picked,
    TripDocument? existing,
    Trip? trip,
  }) {
    final resolvedTrip =
        trip ?? ref.read(tripDetailProvider(widget.tripId)).asData?.value;
    showVentusSheet<void>(
      context,
      builder: (_) => _DocumentSheet(
        tripId: widget.tripId,
        trip: resolvedTrip,
        picked: picked,
        existing: existing,
      ),
    );
  }
}

/// Number of day options to offer (trip length, at least 1).
int _documentDayCount(Trip? trip) =>
    ((trip?.nights ?? 0) + 1).clamp(1, 1 << 30);

/// One grouped card of document rows with an eyebrow header.
class _GroupBlock extends StatelessWidget {
  const _GroupBlock({
    required this.title,
    required this.docs,
    required this.subFor,
    required this.onOpen,
    required this.onMore,
  });

  /// Null hides the eyebrow (a single-type filter makes it redundant).
  final String? title;
  final List<TripDocument> docs;
  final String? Function(TripDocument) subFor;
  final ValueChanged<TripDocument> onOpen;
  final ValueChanged<TripDocument> onMore;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            VentusSectionLabel(
              title!,
              padding: const EdgeInsets.only(left: 2, bottom: 8),
            ),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.brLg,
              boxShadow: context.shadows.card,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (var i = 0; i < docs.length; i++)
                    _DocRow(
                      doc: docs[i],
                      sub: subFor(docs[i]),
                      last: i == docs.length - 1,
                      onTap: () => onOpen(docs[i]),
                      onMore: () => onMore(docs[i]),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocRow extends StatelessWidget {
  const _DocRow({
    required this.doc,
    required this.sub,
    required this.last,
    required this.onTap,
    required this.onMore,
  });

  final TripDocument doc;
  final String? sub;
  final bool last;
  final VoidCallback onTap;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final meta = [
      if (doc.ext != null) doc.ext!,
      if (formatFileSize(doc.sizeBytes).isNotEmpty)
        formatFileSize(doc.sizeBytes),
      ?sub,
    ].join(' · ');

    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            DocThumb(type: doc.type, ext: doc.ext),
            const SizedBox(width: 13),
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
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            VentusTap(
              onTap: onMore,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: VentusIcon(
                  VentusIcons.more,
                  size: 18,
                  color: colors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  const _EmptyDocuments({required this.onUpload});

  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return VentusEmptyState(
      icon: VentusIcons.document,
      title: l10n.emptyDocumentsTitle,
      body: l10n.emptyDocumentsBody,
      action: VentusButton(
        label: l10n.uploadDocument,
        iconLeft: VentusIcons.plus,
        onPressed: onUpload,
      ),
    );
  }
}

/// The three upload sources from the design.
enum _DocSource { files, camera, photos }

/// "Add a document" sheet — pick where the file comes from.
class _SourceSheet extends StatelessWidget {
  const _SourceSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          10,
          AppSpacing.screen,
          22,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: colors.lineStrong,
                  borderRadius: AppRadius.brFull,
                ),
              ),
            ),
            Text(
              l10n.addDocumentTitle,
              style: context.typography.h2.copyWith(
                fontSize: AppFontSize.h3,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.addDocumentBody,
              style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
            ),
            const SizedBox(height: 8),
            _SourceRow(
              icon: VentusIcons.folder,
              title: l10n.sourceFiles,
              sub: l10n.sourceFilesSub,
              onTap: () => Navigator.of(context).pop(_DocSource.files),
            ),
            _SourceRow(
              icon: VentusIcons.camera,
              title: l10n.sourceCamera,
              sub: l10n.sourceCameraSub,
              onTap: () => Navigator.of(context).pop(_DocSource.camera),
            ),
            _SourceRow(
              icon: VentusIcons.image,
              title: l10n.sourcePhotos,
              sub: l10n.sourcePhotosSub,
              last: true,
              onTap: () => Navigator.of(context).pop(_DocSource.photos),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.icon,
    required this.title,
    required this.sub,
    required this.onTap,
    this.last = false,
  });

  final String icon;
  final String title;
  final String sub;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surfaceSand,
                borderRadius: AppRadius.brSm,
              ),
              child: VentusIcon(icon, size: 21, color: colors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
            VentusIcon(VentusIcons.chevronRight, size: 18, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

/// Assign a freshly picked file (upload) or edit an existing document: type,
/// linked day, and — when editing — the display name.
class _DocumentSheet extends ConsumerStatefulWidget {
  const _DocumentSheet({
    required this.tripId,
    required this.trip,
    this.picked,
    this.existing,
  });

  final String tripId;
  final Trip? trip;
  final PickedDocument? picked;
  final TripDocument? existing;

  @override
  ConsumerState<_DocumentSheet> createState() => _DocumentSheetState();
}

class _DocumentSheetState extends ConsumerState<_DocumentSheet> {
  late final TextEditingController _name;
  late DocumentType _type;
  int? _day;

  bool get _isEdit => widget.existing != null;

  /// What an upload is called when the user leaves the name blank: the file's
  /// own name when it has a real one, otherwise its type ("Ticket").
  String _defaultName(AppLocalizations l10n) {
    final f = widget.picked?.filename;
    if (f == null || _isTechnicalFileName(f)) {
      return documentTypeLabel(l10n, _type);
    }
    return _readableBaseName(f);
  }

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    // On upload leave the name empty so the hint invites a friendly name
    // (e.g. "France ticket"); it falls back to the file name if left blank.
    _name = TextEditingController(text: e?.name ?? '');
    _type = e?.type ?? DocumentType.ticket;
    _day = e?.day;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final saving = ref.watch(documentsControllerProvider).isLoading;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            10,
            AppSpacing.screen,
            22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: colors.lineStrong,
                    borderRadius: AppRadius.brFull,
                  ),
                ),
              ),
              Text(
                _isEdit ? l10n.editDocumentTitle : l10n.saveDocumentTitle,
                style: context.typography.h2.copyWith(
                  fontSize: AppFontSize.h3,
                  fontWeight: FontWeight.w700,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 16),
              if (widget.picked != null) ...[
                _PickedPreview(picked: widget.picked!, type: _type),
                const SizedBox(height: 18),
              ],
              _FieldLabel(l10n.documentNameLabel),
              const SizedBox(height: 8),
              VentusTextField(
                controller: _name,
                hintText: _isEdit ? l10n.documentNameHint : _defaultName(l10n),
                icon: VentusIcons.document,
              ),
              const SizedBox(height: 18),
              _FieldLabel(l10n.documentTypeLabel),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in DocumentType.values)
                    VentusChip(
                      label: documentTypeLabel(l10n, t),
                      active: t == _type,
                      onTap: () => setState(() => _type = t),
                    ),
                ],
              ),
              // The day link stays in the Edit sheet only — uploads default to
              // trip-wide and can be linked to a day later if wanted.
              if (_isEdit) ...[
                const SizedBox(height: 18),
                _FieldLabel(l10n.linkToDayLabel),
                const SizedBox(height: 8),
                _DayField(label: _dayLabel(l10n), onTap: _pickDay),
              ],
              const SizedBox(height: 24),
              VentusButton(
                label: _isEdit ? l10n.save : l10n.saveToDocuments,
                iconLeft: VentusIcons.check,
                full: true,
                loading: saving,
                onPressed: () => _save(context),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: saving ? null : () => _delete(context),
                    child: Text(
                      l10n.deleteDocument,
                      style: TextStyle(
                        color: colors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _dayLabel(AppLocalizations l10n) {
    if (_day == null) return l10n.docGroupTripWide;
    final date = dayDate(widget.trip, _day!);
    return date == null
        ? l10n.docDayShort(_day!)
        : l10n.docDayWithDate(
            _day!,
            DateFormat.MMMMEEEEd(context.languageCode).format(date),
          );
  }

  Future<void> _pickDay() async {
    final l10n = context.l10n;
    final lang = context.languageCode;
    final dayCount = _documentDayCount(widget.trip);
    // -1 is the "Trip-wide" sentinel; null means the picker was dismissed.
    final picked = await showVentusOptionSheet<int>(
      context,
      options: [
        VentusSheetOption(
          value: -1,
          label: l10n.docGroupTripWide,
          selected: _day == null,
        ),
        for (var d = 1; d <= dayCount; d++)
          VentusSheetOption(
            value: d,
            label: () {
              final date = dayDate(widget.trip, d);
              return date == null
                  ? l10n.docDayShort(d)
                  : l10n.docDayWithDate(d, DateFormat.MMMd(lang).format(date));
            }(),
            selected: _day == d,
          ),
      ],
    );
    if (picked == null) return;
    setState(() => _day = picked == -1 ? null : picked);
  }

  Future<void> _save(BuildContext context) async {
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final notifier = ref.read(documentsControllerProvider.notifier);

    final bool ok;
    if (_isEdit) {
      final name = _name.text.trim();
      ok = await notifier.edit(
        widget.existing!.copyWith(
          name: name.isEmpty ? widget.existing!.name : name,
          type: _type,
          day: _day,
        ),
      );
    } else {
      ok = await notifier.upload(
        tripId: widget.tripId,
        picked: widget.picked!,
        type: _type,
        name: _name.text.trim().isEmpty ? _defaultName(l10n) : _name.text,
        day: _day,
      );
    }
    if (!context.mounted) return;
    if (ok) {
      navigator.pop();
    } else {
      showVentusError(
        context,
        l10n.uploadFailed,
        onRetry: () => _save(context),
      );
    }
  }

  Future<void> _delete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    // Matches the confirm the document *detail* screen already had; this path
    // deleted the file outright.
    final confirmed = await confirmVentusAction(
      context,
      title: l10n.deleteDocumentTitle,
      body: l10n.deleteDocumentBody,
      confirmLabel: l10n.deleteConfirm,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final ok = await ref
        .read(documentsControllerProvider.notifier)
        .delete(widget.existing!);
    if (!context.mounted) return;
    if (ok) {
      showVentusSuccess(context, l10n.documentDeleted);
      navigator.pop();
    } else {
      showVentusError(context, l10n.somethingWentWrong);
    }
  }
}

/// Read-only preview of a freshly picked file in the upload sheet.
/// Camera / gallery pickers hand back throwaway names ("image_picker_A194EA2F-…");
/// those are meaningless to the user and shouldn't become a document's name.
bool _isTechnicalFileName(String filename) {
  final base = filename.split('.').first;
  return base.startsWith('image_picker') ||
      base.startsWith('scaled_') ||
      RegExp(r'^[0-9A-Fa-f-]{16,}$').hasMatch(base);
}

/// The file name minus its extension, with separators turned into spaces.
String _readableBaseName(String filename) {
  final dot = filename.lastIndexOf('.');
  final base = dot > 0 ? filename.substring(0, dot) : filename;
  return base.replaceAll(RegExp(r'[_-]+'), ' ').trim();
}

class _PickedPreview extends StatelessWidget {
  const _PickedPreview({required this.picked, required this.type});

  final PickedDocument picked;
  final DocumentType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = formatFileSize(picked.sizeBytes);
    final meta = [
      if (picked.ext != null) picked.ext!,
      if (size.isNotEmpty) size,
    ].join(' · ');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceSand,
        borderRadius: AppRadius.brLg,
      ),
      child: Row(
        children: [
          DocThumb(type: type, ext: picked.ext, size: 42),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isTechnicalFileName(picked.filename)
                      ? (picked.mimeType?.startsWith('image/') ?? false
                            ? context.l10n.docPhotoName
                            : context.l10n.docFileName)
                      : picked.filename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          VentusIcon(VentusIcons.check, size: 20, color: colors.success),
        ],
      ),
    );
  }
}

class _DayField extends StatelessWidget {
  const _DayField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        height: AppSizes.controlLg,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brMd,
          boxShadow: context.shadows.card,
        ),
        child: Row(
          children: [
            VentusIcon(VentusIcons.calendar, size: 18, color: colors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
            ),
            VentusIcon(VentusIcons.chevronDown, size: 17, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.typography.sm.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.ink2,
      ),
    );
  }
}
