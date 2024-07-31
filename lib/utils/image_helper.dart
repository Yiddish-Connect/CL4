import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
      _imageCropper = imageCropper ?? ImageCropper();

  final ImageCropper _imageCropper;
  final ImagePicker _imagePicker;

  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
  }) async {

    final XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );

    if (file != null) return [file];
    return [];
  }

  Future<CroppedFile?> crop({
    required XFile file,
    required BuildContext context,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async => 
    await _imageCropper.cropImage(
      // cropStyle: cropStyle,
      sourcePath: file.path,
      compressQuality: 100,
      uiSettings: [
        IOSUiSettings(),
        AndroidUiSettings(),
        WebUiSettings(
          context: context,
          size: const CropperSize(
            width: 500,
            height: 400
          ),
        )
      ],);
}
