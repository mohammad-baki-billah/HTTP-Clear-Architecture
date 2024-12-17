import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http_clear_architecture_part_1/network_manager/rest_client.dart';
import 'package:http_clear_architecture_part_1/utils/toast_measseage.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isLoading = false;
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          'UploadScreen',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  selectedImage = File(file.path);
                  setState(() {});
                }
              },
              child: Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.green.shade100),
                child: selectedImage == null
                    ? const Text(
                        "Select image from the grallery",
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      )
                    : Image.file(selectedImage!),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            SizedBox(
              height: 58.0,
              width: 200.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shadowColor: Colors.green.shade100,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  if (selectedImage != null) {
                    setState(() {
                      isLoading = true;
                    });
                    RestClient.uploadImages(selectedImage!).then((value) {
                      print("Image Url==> ${value!.location}");
                      setState(() {
                        isLoading = false;
                      });
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                      print(error.toString());
                    });
                  } else {
                    toastMessage('please Select Image');
                  }
                },
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
