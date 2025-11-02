import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/screens/blog_card.dart';
import 'package:blog_beispiel/services/blog_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogOverview extends StatefulWidget {
  const BlogOverview({super.key});

  @override
  State<BlogOverview> createState() => _BlogOverviewState();
}

class _BlogOverviewState extends State<BlogOverview> {
  final blogService = BlogService();
  late Future<List<Blog>> _blogsFuture;

  @override
  void initState() {
    super.initState();
    _blogsFuture = blogService.getBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Blog overview"),
      ),
      body: Center(
        child: FutureBuilder<List<Blog>>(
          future: _blogsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Fehler beim Laden der Blogs: ${snapshot.error}");
            } else if (snapshot.hasData) {
              final List<Blog> blogs = snapshot.data!;
              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  return BlogCard(
                    blog: blogs[index],
                    dateFormatter: DateFormat('dd.MM.yyyy'),
                  );
                },
              );
            } else {
              return const Text("Keine Blogeinträge gefunden.");
            }
          },
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
