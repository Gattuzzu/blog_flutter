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
  List<Blog> getBlogs() => testBlogs;
}
