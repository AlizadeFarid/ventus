import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_storage.dart';
import '../../../core/utils/id.dart';
import '../data/document_picker.dart';
import '../domain/document.dart';
import '../domain/document_type.dart';
import 'documents_providers.dart';

/// Drives document write actions (upload / edit / delete) and exposes their
/// loading + error state. Reads stay reactive through [documentsProvider]; this
/// only owns the mutations so screens can show spinners and surface failures.
class DocumentsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Uploads a freshly [picked] file: builds the owner-scoped Storage path,
  /// pushes the binary, then saves the metadata.
  Future<bool> upload({
    required String tripId,
    required PickedDocument picked,
    required DocumentType type,
    String? name,
    int? day,
  }) {
    return _run(() async {
      final id = newId();
      final userId = AppStorage.currentUserId;
      final ext = picked.ext;
      final suffix = ext == null ? '' : '.${ext.toLowerCase()}';
      // Path must start with the user's id for the owner Storage RLS to pass.
      final path = AppStorage.userScopedPath(
        userId ?? 'local',
        '$tripId/$id$suffix',
      );
      // Use the user-typed display name; fall back to the raw file name.
      final displayName = (name == null || name.trim().isEmpty)
          ? picked.filename
          : name.trim();
      final doc = TripDocument(
        id: id,
        tripId: tripId,
        userId: userId,
        name: displayName,
        type: type,
        storagePath: path,
        ext: ext,
        mimeType: picked.mimeType,
        sizeBytes: picked.sizeBytes,
        day: day,
        createdAt: DateTime.now(),
      );
      await ref
          .read(documentsRepositoryProvider)
          .upload(doc, picked.bytes, contentType: picked.mimeType);
    });
  }

  /// Saves metadata-only edits (rename / retype / relink day).
  Future<bool> edit(TripDocument doc) =>
      _run(() => ref.read(documentsRepositoryProvider).update(doc));

  Future<bool> delete(TripDocument doc) =>
      _run(() => ref.read(documentsRepositoryProvider).delete(doc));

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final documentsControllerProvider =
    AsyncNotifierProvider<DocumentsController, void>(DocumentsController.new);
