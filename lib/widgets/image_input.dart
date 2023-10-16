import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    required this.setImage,
    required this.imageUrl,
  });

  final void Function(XFile img) setImage;
  final String imageUrl;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? image;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    if (img == null) {
      return;
    }
    widget.setImage(img);
    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void myAlert() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        alignment: Alignment.center,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              //if user click this button, user can upload image from gallery
              onPressed: () {
                Navigator.pop(context);
                getImage(ImageSource.gallery);
              },
              child: const Column(
                children: [
                  Icon(
                    Icons.image,
                    size: 50,
                  ),
                  Text('Gallery'),
                ],
              ),
            ),
            TextButton(
              //if user click this button. user can upload image from camera
              onPressed: () {
                Navigator.pop(context);
                getImage(ImageSource.camera);
              },

              child: const Column(
                children: [
                  Icon(
                    Icons.camera,
                    size: 50,
                  ),
                  Text('Camera'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              myAlert();
            },
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  width: 120,
                  height: 120,
                  child: image != null
                      ? Image.file(
                          File(image!.path),
                          fit: BoxFit.cover,
                          width: 120,
                        )
                      : Image.network(
                          widget.imageUrl,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.edit,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
