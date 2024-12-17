import 'package:flutter/material.dart';
import 'package:http_clear_architecture_part_1/models/put_api_model.dart';
import 'package:http_clear_architecture_part_1/network_manager/rest_client.dart';

class PutApiScreen extends StatefulWidget {
  const PutApiScreen({super.key});

  @override
  State<PutApiScreen> createState() => _PutApiScreenState();
}

class _PutApiScreenState extends State<PutApiScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  bool isLoding = false;
  PutApiModel putApiModel = PutApiModel();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  getPutdata() {
    Map<String, dynamic> pragma = {
      "name": nameController.text,
      "job": jobController.text,
    };

    setState(() {
      isLoding = true;
    });

    RestClient.putUpdateUser(pragma).then((value) {
      setState(() {
        if (value != null) {
          putApiModel = value;
          nameController.clear();
          jobController.clear();
        }
        isLoding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User updated successfully!")),
      );
    }).onError((error, stackTrace) {
      setState(() {
        isLoding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${error.toString()}")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          'PutAPI',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: 'Enter Name',
                    labelStyle: const TextStyle(
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your Name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: jobController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Enter Job",
                  labelStyle: const TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your Job';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 58,
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: isLoding
                      ? null
                      : () {
                          if (formKey.currentState?.validate() == true) {
                            getPutdata();
                          }
                        },
                  child: isLoding
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
