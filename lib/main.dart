import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/screens/blog_overview.dart';
import 'package:blog_beispiel/services/blog_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlogOverview(),
    );
  }
}
