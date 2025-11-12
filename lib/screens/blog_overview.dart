import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/screens/blog_card.dart';
import 'package:blog_beispiel/screens/navigation.dart';
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
  late Stream<List<Blog>> _blogsStream;

  @override
  void initState() {
    super.initState();
    _blogsStream = blogService.getBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Blog overview"),
      ),
      body: Center(
        child: StreamBuilder<List<Blog>>(
          stream: _blogsStream,
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
                  final Blog currentBlog = blogs[index];
                  return BlogCard(
                    blog: currentBlog,
                    dateFormatter: DateFormat('dd.MM.yyyy'),
                    onLikeToggle: () => onToggleLikeStatus(currentBlog),
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

      drawer: Navigation(),
    );
  }

  void onAddBlog() => {
    blogService.addBlog(
      Blog(
        id: 99,
        title: "Neuester Blog",
        content: "Neuer Inhalt im neuen Blog.",
        date: DateTime.now(),
        liked: false,
      ),
    ),
  };

  void onToggleLikeStatus(Blog blog){
    blog.liked = !blog.liked;
    blogService.updateBlog(blog);
  }
}
