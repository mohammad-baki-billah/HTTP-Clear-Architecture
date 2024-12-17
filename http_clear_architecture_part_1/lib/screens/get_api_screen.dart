import 'package:flutter/material.dart';
import 'package:http_clear_architecture_part_1/models/user_list_array.dart';
import 'package:http_clear_architecture_part_1/models/user_list_object.dart';
import 'package:http_clear_architecture_part_1/network_manager/rest_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  UserListObject userListObject = UserListObject();
  List<UserListArray> userListArray = [];

  userList() {
    RestClient.getUserListArray().then((value) {
      setState(() {
        //userListObject = value!;
        userListArray = value;
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
        print(error.toString());
      });
    });
  }

  @override
  void initState() {
    userList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'HomeScreen',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            ))
          : ListView.builder(
              itemCount: userListArray.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   child: Image.network(
                    //       userListObject.data![index].avatar.toString()),
                    // ),
                    title: Text(userListArray[index].title.toString()),
                  ),
                );
              },
            ),
    );
  }
}
