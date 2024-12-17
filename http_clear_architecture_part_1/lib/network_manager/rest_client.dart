import 'dart:io';

import 'package:http_clear_architecture_part_1/models/put_api_model.dart';
import 'package:http_clear_architecture_part_1/models/upload_image.dart';
import 'package:http_clear_architecture_part_1/models/user_list_array.dart';
import 'package:http_clear_architecture_part_1/models/user_list_object.dart';
import 'package:http_clear_architecture_part_1/network_manager/http_helper.dart';
import 'package:http_clear_architecture_part_1/utils/toast_measseage.dart';

class RestClient {
  static final HttpHelper _httpHelper = HttpHelper();

  /// Fetches User List Object from API
  static Future<UserListObject?> getUserListObject() async {
    const String url = "https://reqres.in/api/users?page=2";
    try {
      // Make GET API request
      final Map<String, dynamic> response = await _httpHelper.getAPI(url: url);
      return UserListObject.fromJson(response);
    } catch (e) {
      // Display error message
      toastMessage("Error in getUserListObject: $e");
      return null;
    }
  }

  /// Fetches User List Array from API
  static Future<List<UserListArray>> getUserListArray() async {
    try {
      List<dynamic> response = await _httpHelper.getAPI(
          url: 'https://jsonplaceholder.typicode.com/todos');
      return List<UserListArray>.from(
        response.map((x) => UserListArray.fromJson(x)),
      );
    } catch (e) {
      print("Error in getUserListArray: $e");
      return []; // Return an empty list on error
    }
  }

  static Future<dynamic> postRegistation(Object requestBody) async {
    try {
      var response = await _httpHelper.postAPI(
          url: 'https://reqres.in/api/register', requestBody: requestBody);
      return response;
    } catch (e) {
      print('error $e');
    }
  }

  static Future<PutApiModel?> putUpdateUser(Object requestBody) async {
    try {
      var response = await _httpHelper.postAPI(
          url: 'https://reqres.in/api/users/2', requestBody: requestBody);
      return PutApiModel.fromJson(response);
    } catch (e) {
      print('error $e');
    }
    return null;
  }

  static Future<dynamic> deleteUserData(String id) async {
    try {
      var response =
          await _httpHelper.deleteAPI(url: 'https://reqres.in/api/users/$id');
      return response;
    } catch (e) {
      print('Error==>$e');
    }
  }

  static Future<UploadImage?> uploadImages(File image) async {
    try {
      var response = await _httpHelper.uploadImage(
          imageFile: image,
          url: 'https://api.escuelajs.co/api/v1/files/upload');
      return UploadImage.fromJson(response);
    } catch (e) {
      print("Upload Image Error ==> $e");
    }
    return null;
  }
}
