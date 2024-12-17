import 'package:flutter/material.dart';
import 'package:http_clear_architecture_part_1/screens/post_api_screen.dart';
import 'package:http_clear_architecture_part_1/screens/upload_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const UploadScreen(),
    );
  }
}
