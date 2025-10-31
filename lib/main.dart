import 'package:blog_beispiel/blog.dart';
import 'package:blog_beispiel/blog_service.dart';
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
      home: const MyBlogPage(title: 'Blog'),
    );
  }
}

class MyBlogPage extends StatefulWidget {
  const MyBlogPage({super.key, required this.title});

  final String title;

  @override
  State<MyBlogPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyBlogPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: blogs.map((item) => BlogCard(blog: item)).toList(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BlogCard extends StatelessWidget {
  const BlogCard({super.key, required this.blog});

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(blog.title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(blog.content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(blog.date),
                Icon(blog.liked ? Icons.favorite : Icons.heart_broken),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
