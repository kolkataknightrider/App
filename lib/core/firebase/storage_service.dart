// ════════════════════════════════════════════════════════════════
// FILE: lib/core/firebase/storage_service.dart
// Profile photo upload/download (Firebase Storage).
// ════════════════════════════════════════════════════════════════

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

/// Handles profile photo storage and selection.
class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Picks an image from gallery or camera.
  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  /// Uploads a profile photo and returns its download URL.
  Future<String> uploadProfilePhoto(String userId, File file) async {
    final ref = _storage.ref().child('profile_photos').child('$userId.jpg');
    final task = await ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return task.ref.getDownloadURL();
  }

  /// Deletes the user's profile photo.
  Future<void> deleteProfilePhoto(String userId) async {
    try {
      await _storage
          .ref()
          .child('profile_photos')
          .child('$userId.jpg')
          .delete();
    } on FirebaseException {
      // ignore if it doesn't exist
    }
  }
}
