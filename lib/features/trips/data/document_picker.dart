import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/// A file the user picked, ready to be uploaded as a [TripDocument].
class PickedDocument {
  const PickedDocument({
    required this.filename,
    required this.bytes,
    this.mimeType,
  });

  /// Original file name including its extension (e.g. `boarding-pass.pdf`).
  final String filename;
  final Uint8List bytes;
  final String? mimeType;

  /// File size in bytes.
  int get sizeBytes => bytes.length;

  /// Uppercase extension label for the thumbnail (e.g. `PDF`), or null.
  String? get ext {
    final dot = filename.lastIndexOf('.');
    if (dot < 0 || dot == filename.length - 1) return null;
    return filename.substring(dot + 1).toUpperCase();
  }
}

/// Picks documents from the three sources in the design (Files / Camera /
/// Photos), returning the bytes + name so the upload flow stays backend-only.
/// Returns null when the user cancels.
abstract final class DocumentPicker {
  static final ImagePicker _images = ImagePicker();

  /// Any file via the system file browser (PDF, Pages, etc.).
  static Future<PickedDocument?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    final file = result?.files.singleOrNull;
    final bytes = file?.bytes;
    if (file == null || bytes == null) return null;
    return PickedDocument(
      filename: file.name,
      bytes: bytes,
      mimeType: _mimeFromExt(file.extension),
    );
  }

  /// Scan a paper ticket or ID with the camera.
  static Future<PickedDocument?> pickFromCamera() =>
      _fromImagePicker(ImageSource.camera);

  /// Pick an existing photo from the library.
  static Future<PickedDocument?> pickFromGallery() =>
      _fromImagePicker(ImageSource.gallery);

  static Future<PickedDocument?> _fromImagePicker(ImageSource source) async {
    final x = await _images.pickImage(source: source, imageQuality: 88);
    if (x == null) return null;
    final bytes = await x.readAsBytes();
    final name = x.name.isEmpty ? 'photo.jpg' : x.name;
    return PickedDocument(
      filename: name,
      bytes: bytes,
      mimeType: x.mimeType ?? _mimeFromExt(name.split('.').lastOrNull),
    );
  }
}

/// Best-effort MIME type from a file extension, for the Storage content-type.
String? _mimeFromExt(String? ext) {
  switch (ext?.toLowerCase()) {
    case 'pdf':
      return 'application/pdf';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'webp':
      return 'image/webp';
    case 'heic':
      return 'image/heic';
    case 'doc':
      return 'application/msword';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    case 'txt':
      return 'text/plain';
    default:
      return null;
  }
}
