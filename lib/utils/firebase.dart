  import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageToFirebase(String img) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user_pictures/${DateTime.now().toIso8601String()}");
    UploadTask uploadTask = ref.putFile(File(img));

    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }