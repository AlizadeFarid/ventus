import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// An image the user picked for their avatar, ready to upload.
class PickedAvatar {
  const PickedAvatar({required this.bytes, this.contentType});

  final Uint8List bytes;
  final String? contentType;
}

/// Picks a square-ish avatar image from the camera or photo library. Returns
/// null when the user cancels. Keeps presentation free of plugin details.
abstract final class AvatarPicker {
  static final ImagePicker _images = ImagePicker();

  static Future<PickedAvatar?> fromCamera() => _pick(ImageSource.camera);

  static Future<PickedAvatar?> fromGallery() => _pick(ImageSource.gallery);

  static Future<PickedAvatar?> _pick(ImageSource source) async {
    final x = await _images.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (x == null) return null;
    final bytes = await x.readAsBytes();
    return PickedAvatar(
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
