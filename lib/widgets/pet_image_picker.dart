import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  void _pickImage() async {
    var pickedImage;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose an option'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                pickedImage = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxWidth: 150,
                );

                if (pickedImage == null) {
                  return;
                }

                setState(() {
                  _pickedImageFile = File(pickedImage.path);
                });
                widget.onPickImage(_pickedImageFile!);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 132, 148),
              ),
              child: const Text('Camera'),
            ),
            ElevatedButton(
              onPressed: () async {
                pickedImage = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                  maxWidth: 150,
                );
                if (pickedImage == null) {
                  return;
                }

                setState(() {
                  _pickedImageFile = File(pickedImage.path);
                });
                widget.onPickImage(_pickedImageFile!);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 241, 132, 148),
              ),
              child: const Text('Gallery'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(
              Icons.image,
              color: Colors.black,
            ),
            label: const Text(
              'Add Image',
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }
}
