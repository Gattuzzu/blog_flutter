import 'package:blog_beispiel/blog.dart';

List<Blog> blogs = [
  Blog(
    title: "Lorem ipsum",
    content: "Blabliblub",
    date: "31.10.2025",
    liked: false,
  ),
  Blog(
    title: "Lorem ipsum",
    content: "Blabliblub",
    date: "31.10.2025",
    liked: false,
  ),
  Blog(
    title: "Pause!!!!!!!!!!!!!!!!!!!!",
    content: "Blabliblub",
    date: "31.10.2025",
    liked: true,
  ),
];

class BlogService {
  List<Blog> getBlogs() => blogs;
}
