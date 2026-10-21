import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// An image the user picked for a trip cover, ready to upload.
class PickedCover {
  const PickedCover({required this.bytes, this.contentType});

  final Uint8List bytes;
  final String? contentType;
}

/// Picks a landscape-ish trip cover image from the camera or photo library.
/// Returns null when the user cancels. Kept separate from the profile
/// [AvatarPicker] (different aspect, different feature) so the two stay
/// decoupled, mirroring its shape.
abstract final class CoverPicker {
  static final ImagePicker _images = ImagePicker();

  static Future<PickedCover?> fromCamera() => _pick(ImageSource.camera);

  static Future<PickedCover?> fromGallery() => _pick(ImageSource.gallery);

  static Future<PickedCover?> _pick(ImageSource source) async {
    final x = await _images.pickImage(
      source: source,
      imageQuality: 82,
      maxWidth: 1600,
      maxHeight: 1200,
    );
    if (x == null) return null;
    final bytes = await x.readAsBytes();
    return PickedCover(
      bytes: bytes,
      contentType: x.mimeType ?? _mimeFromName(x.name),
    );
  }

  static String? _mimeFromName(String name) {
    final ext = name.split('.').lastOrNull?.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      default:
        return null;
    }
  }
}
