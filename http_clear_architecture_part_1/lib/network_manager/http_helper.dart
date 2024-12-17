import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_clear_architecture_part_1/utils/print_value.dart';
import 'package:http_clear_architecture_part_1/utils/toast_measseage.dart';

/// HttpHelper - A reusable service class for making HTTP requests
class HttpHelper {
  final http.Client _client;

  /// Constructor with dependency injection
  HttpHelper({http.Client? client}) : _client = client ?? http.Client();

  /// Builds API headers with optional authorization
  Map<String, String> _buildHeaders({bool isRequiredAuthorization = false}) {
    return {
      "Content-Type": "application/json",
      if (isRequiredAuthorization) "Authorization": "Bearer userBearerToken",
    };
  }

  /// Handles GET requests
  Future<dynamic> getAPI({
    required String url,
    bool isRequiredAuthorization = false,
  }) async {
    final headers = _buildHeaders(isRequiredAuthorization: isRequiredAuthorization);
    try {
      final response = await _client.get(Uri.parse(url), headers: headers);
      printValue(url, tag: 'API GET URL:');
      printValue(headers, tag: 'API HEADERS:');
      printValue(response.body, tag: 'API RESPONSE:');
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handles POST requests
  Future<dynamic> postAPI({
    required String url,
    Object? requestBody,
    bool isRequiredAuthorization = false,
  }) async {
    final headers = _buildHeaders(isRequiredAuthorization: isRequiredAuthorization);
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody != null ? jsonEncode(requestBody) : null,
      );
      printValue(url, tag: 'API POST URL:');
      printValue(requestBody, tag: 'API REQUEST BODY:');
      printValue(headers, tag: "API HEADERS:");
      printValue(response.body, tag: 'API RESPONSE:');
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handles PUT requests
  Future<dynamic> putAPI({
    required String url,
    Object? requestBody,
    bool isRequiredAuthorization = false,
  }) async {
    final headers = _buildHeaders(isRequiredAuthorization: isRequiredAuthorization);
    try {
      final response = await _client.put(
        Uri.parse(url),
        headers: headers,
        body: requestBody != null ? jsonEncode(requestBody) : null,
      );
      printValue(url, tag: 'API PUT URL:');
      printValue(requestBody, tag: 'API REQUEST BODY:');
      printValue(headers, tag: "API HEADERS:");
      printValue(response.body, tag: 'API RESPONSE:');
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handles DELETE requests
  Future<dynamic> deleteAPI({
  required String url,
  Object? requestBody,
  bool isRequiredAuthorization = false,
}) async {
  final headers = _buildHeaders(isRequiredAuthorization: isRequiredAuthorization);
  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
      body: requestBody != null ? jsonEncode(requestBody) : null,
    );

    printValue(url, tag: 'API DELETE URL:');
    printValue(requestBody, tag: 'API REQUEST BODY:');
    printValue(headers, tag: "API HEADERS:");
    printValue(response.body, tag: 'API RESPONSE:');

    return _handleResponse(response);
  } on SocketException {
    toastMessage('No internet connection');
    return null;
  } catch (e) {
    toastMessage('An unexpected error occurred: $e');
    return null;
  }
}


  /// Handles file uploads
  Future<dynamic> uploadImage({
    required File imageFile,
    required String url,
    bool isRequiredAuthorization = false,
  }) async {
    try {
      final headers = _buildHeaders(isRequiredAuthorization: isRequiredAuthorization);
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await http.Response.fromStream(await request.send());

      printValue(url, tag: 'API UPLOAD URL:');
      printValue(headers, tag: "API HEADERS:");
      printValue(response.body, tag: 'API RESPONSE:');

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Handles HTTP response
  dynamic _handleResponse(http.Response response) {
    printValue(response.statusCode, tag: "HTTP STATUS:");
    try {
      switch (response.statusCode) {
        case 200:
        case 201:
        case 204:
          return jsonDecode(response.body);
        case 400:
          final error = jsonDecode(response.body);
          toastMessage(error.toString());
          throw Exception('Bad Request: ${error['error'] ?? response.statusCode}');
        case 401:
          throw Exception('Unauthorized: ${response.statusCode}');
        case 500:
          throw Exception('Internal Server Error: ${response.statusCode}');
        default:
          throw Exception('Unexpected Error: ${response.statusCode}');
      }
    } catch (e) {
      // Return raw response if JSON parsing fails
      return response.body;
    }
  }

  /// Handles errors
  dynamic _handleError(Object error) {
    if (error is SocketException) {
      toastMessage("No internet connection");
      return null;
    } else {
      toastMessage("An unexpected error occurred: $error");
      return null;
    }
  }
}
