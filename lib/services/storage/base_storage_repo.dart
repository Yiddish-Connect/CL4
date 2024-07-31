import 'package:image_picker/image_picker.dart';

abstract class BaseStorageRepo{
  Future<void> uploadImage(XFile image);
}