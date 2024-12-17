import 'dart:convert';
import 'dart:developer'; // For using log()
import 'package:flutter/foundation.dart'; // For kDebugMode and kReleaseMode

void printValue(dynamic value, {String tag = "[DEBUG]"}) {
  // Skip logging in release mode
  if (kReleaseMode) return;

  try {
    if (value is String && _isJson(value)) {
      // Handle JSON string
      final decodedJSON = json.decode(value);
      log("JSON OUTPUT: $tag ${const JsonEncoder.withIndent('  ').convert(decodedJSON)}\n");
    } else if (value is Map<String, dynamic>) {
      // Handle Map directly
      log("JSON OUTPUT: $tag ${const JsonEncoder.withIndent('  ').convert(value)}\n");
    } else if (value is List<dynamic>) {
      // Handle List directly
      log("LIST OUTPUT: $tag ${const JsonEncoder.withIndent('  ').convert(value)}\n");
    } else {
      // Handle general non-JSON values
      log("PRINT OUTPUT: $tag $value\n");
    }
  } catch (e, stackTrace) {
    // Log error details
    log("ERROR in printValue: $e\nStackTrace: $stackTrace\nTag: $tag Value: $value\n");
  }
}

/// Helper function to check if a string might be JSON
bool _isJson(String str) {
  return (str.startsWith('{') && str.endsWith('}')) || (str.startsWith('[') && str.endsWith(']'));
}
