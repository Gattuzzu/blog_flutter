import 'dart:async';

import 'package:blog_beispiel/models/blog.dart';
import 'package:flutter/material.dart';

List<Blog> testBlogs = [
  Blog(
    title: "Lorem ipsum",
    content: "Blabliblub",
    publishedAt: DateTime.now(),
  ),
  Blog(
    title: "Lorem ipsum",
    content: "Blabliblub",
    publishedAt: DateTime.parse("2025-10-31"),
  ),
  Blog(
    title: "Pause!!!!!!!!!!!!!!!!!!!!",
    content: "Blabliblub",
    publishedAt: DateTime.parse("2025-10-22"),
  ),
  Blog(
    title: "Flutter ist toll!",
    content: "Mit Flutter hebst du deine App-Entwicklung auf ein neues Level. Probier es aus!",
    publishedAt: DateTime.now(),
  ),
  Blog(
    title: "Der Kurs ist dabei abzuheben",
    content: "Fasten your seatbelts, we are ready for takeoff! Jetzt geht's ans Eingemachte. Bleib dabei!",
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Blog(
    title: "Klasse erzeugt eine super App",
    content: "Während dem aktiven Plenum hat die Klasse alles rausgeholt und eine tolle App gebaut. Alle waren begeistert dabei und haben viel gelernt.",
    publishedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

class BlogRepository extends ChangeNotifier {
  // Static instance + private Constructor for simple Singleton-approach
  static BlogRepository instance = BlogRepository._privateConstructor();
  BlogRepository._privateConstructor();

  final _blogs = <Blog>[];

  int _nextId = 1;

  bool _isInitialized = false;

  void _initializeBlogs() async {
    testBlogs.forEach(addBlogPost); // Alle Testblogs zum BlogRepository hinzufügen.

    _isInitialized = true;
  }

  /// Returns all blog posts ordered by publishedAt descending.
  /// Simulates network delay.
  Future<List<Blog>> getBlogPosts() async {
    if (!_isInitialized) {
      _initializeBlogs();
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    return _blogs..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  // Gibt nur den gewünschten Blog zurück
  Future<Blog> getBlogPost(String blogId) async {
    if (!_isInitialized) {
      _initializeBlogs();
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    return _blogs.firstWhere((blog) => blog.id == blogId);
  }

  /// Creates a new blog post and sets a new id.
  Future<void> addBlogPost(Blog blog) async {
    blog.id = _nextId++;
    _blogs.add(blog);

    notifyListeners();
  }

  /// Deletes a blog post.
  Future<void> deleteBlogPost(Blog blog) async {
    _blogs.remove(blog);

    notifyListeners();
  }

  /// Changes the like info of a blog post.
  Future<void> toggleLikeInfo(String blogId) async {
    final blog = _blogs.firstWhere((blog) => blog.id == blogId);
    blog.isLikedByMe = !blog.isLikedByMe;

    notifyListeners();
  }

  /// Updates a blog post with the given id.
  Future<void> updateBlogPost(
      {required String blogId,
      required String? title,
      required String? content}) async {

    final blog = _blogs.firstWhere((blog) => blog.id == blogId);

    if(title != null){ blog.title = title; }
    if(content != null){ blog.content = content; }

    notifyListeners();
  }
}