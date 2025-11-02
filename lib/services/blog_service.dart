import 'dart:async';

import 'package:blog_beispiel/models/blog.dart';

List<Blog> testBlogs = [
  Blog(
    id: 1,
    title: "Lorem ipsum",
    content: "Blabliblub",
    date: DateTime.now(),
    liked: false,
  ),
  Blog(
    id: 22,
    title: "Lorem ipsum",
    content: "Blabliblub",
    date: DateTime.parse("2025-10-31"),
    liked: false,
  ),
  Blog(
    id: 33,
    title: "Pause!!!!!!!!!!!!!!!!!!!!",
    content: "Blabliblub",
    date: DateTime.parse("2025-10-22"),
    liked: true,
  ),
];

class BlogService {
  final _controller = StreamController<List<Blog>>.broadcast();

  Stream<List<Blog>> getBlogs() {
    Future.delayed(const Duration(seconds: 2), () => {_controller.sink.add(testBlogs)});
    return _controller.stream;
  }

  void addBlog(Blog blog) {
    testBlogs.insert(0, blog); // Index 0 damit der Eintrag zu oberst angezeigt wird.
    _controller.sink.add(testBlogs);
  } 

  void dispose() {
    _controller.close();
  }

  void updateBlog(Blog updatedBlog){
    final index = testBlogs.indexWhere((blog) => blog.id == updatedBlog.id);
    if (index != -1){
      testBlogs[index] = updatedBlog;

      _controller.sink.add(testBlogs);
    }
  }
}
