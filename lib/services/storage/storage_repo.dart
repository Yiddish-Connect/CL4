import 'package:image_picker/image_picker.dart';
import 'package:ydtind/services/storage/base_storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class StorageRepo extends BaseStorageRepo {
  final firebase_storage.FirebaseStorage storage = 
    firebase_storage.FirebaseStorage.instance;

  @override
  Future<void> uploadImage(XFile image) async {
    try {
      await storage.ref('user_1/${image.name}').putFile(File(image.path));
    } catch (_) {
      
    }
  }
}