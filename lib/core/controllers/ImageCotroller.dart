import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();

  /// Reactive states
  List<File> files = [];
  File? singleFile;
  File? coverFile;
  bool isLoading = false;

  /// Pick a single image (camera or gallery)
  Future<void> pickSingle({required ImageSource source}) async {
    _setLoading(true);

    final XFile? picked = await picker.pickImage(source: source);
    if (picked != null) {
      singleFile = File(picked.path);
    } else {
      singleFile = null;
    }

    _setLoading(false);
  }

  /// Pick cover image
  Future<void> pickCover({required ImageSource source}) async {
    _setLoading(true);

    final XFile? picked = await picker.pickImage(source: source);
    if (picked != null) {
      coverFile = File(picked.path);
    } else {
      coverFile = null;
    }

    _setLoading(false);
  }

  /// Pick multiple images (gallery only)
  Future<void> pickMultiple() async {
    _setLoading(true);

    final List<XFile>? multi = await picker.pickMultiImage();
    if (multi != null && multi.isNotEmpty) {
      files.addAll(multi.map((x) => File(x.path))); // 👈 replace nahi, add
    }

    _setLoading(false);
  }

  /// Remove a file from the list
  void removeFileAt(int index) {
    if (index < 0 || index >= files.length) return;
    files.removeAt(index);
  }

  /// Clear everything
  void clearAll() {
    files.clear();
    singleFile = null;
    coverFile = null;
  }

  void _setLoading(bool v) {
    isLoading = v;
  }
}
