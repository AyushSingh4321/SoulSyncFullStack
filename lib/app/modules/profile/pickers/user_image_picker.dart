import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    var pickedImageFile;
    try {
      print('reached at part 1...........');
      try {
         pickedImageFile = await ImagePicker().pickImage(
          source: ImageSource.camera, // You can also use ImageSource.gallery
          imageQuality: 50, // Adjust image quality (1-100)
          maxWidth: 150, // Resize the image
        );
      } catch (e) {
        print('something went wrong with code ${e}');
      }

      if (pickedImageFile == null) {
        // If the user cancels picking the image
        return;
      }

      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickFn(_pickedImage!);
    } catch (error) {
      // If something goes wrong
      print('Image picking failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image. Please try again!'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage ,
          child: CircleAvatar(
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage!) : null,
            backgroundColor: Colors.grey,
            radius: 50,
            // child: Icon(Icons.camera_alt),
          ),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image!'),
        ),
      ],
    );
  }
}
