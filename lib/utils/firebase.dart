import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

Future<dynamic> getUserDetails(String uid) async {
  try {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!userSnapshot.exists) {
      return null;
    }
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
          return userData;
  } catch (e) {
    print(e);
  }
}

