import 'package:blog_beispiel/screens/blog_card.dart';
import 'package:blog_beispiel/services/blog_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogOverview extends StatelessWidget{
  final blogService = BlogService();

  BlogOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Blog overview"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: blogService.getBlogs().map((item) => BlogCard(blog: item, dateFormatter: DateFormat('dd.MM.yyyy'))).toList(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: onAddBlog,
        tooltip: 'Add Blog',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onAddBlog() => {
    // toDo: Add Blog Page hinzufügen
  };
}