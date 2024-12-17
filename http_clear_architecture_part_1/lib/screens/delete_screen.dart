import 'package:flutter/material.dart';
import 'package:http_clear_architecture_part_1/network_manager/rest_client.dart';
import 'package:http_clear_architecture_part_1/utils/toast_measseage.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          'DeleteScreen',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Center(
          child: SizedBox(
        height: 58,
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            setState(() {
              isLoading = true;
            });
            RestClient.deleteUserData('2').then((value) {
              toastMessage('Delete Successfully');
              setState(() {
                isLoading = false;
              });
            }).onError((error, stackTrace) {
              print("Error ==> ${error.toString()}");
            });
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Delete',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ),
      )),
    );
  }
  
}
