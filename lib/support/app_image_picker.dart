import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AppImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<String?> getImageAsBase64() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 10,
      );
      File fileFormat = File(image!.path);
      String base64Image = base64Encode(fileFormat.readAsBytesSync());
      return base64Image;
    } catch (e) {
      return null;
    }
  }
}
