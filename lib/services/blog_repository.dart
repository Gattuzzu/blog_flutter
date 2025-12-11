import 'dart:async';

import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/blog_service.dart';
import 'package:flutter/material.dart';


class BlogRepository extends ChangeNotifier {
  // Static instance + private Constructor for simple Singleton-approach
  static BlogRepository instance = BlogRepository._privateConstructor();
  BlogRepository._privateConstructor();

  var service = BlogService.instance;

  /// Returns all blog posts ordered by publishedAt descending.
  /// Simulates network delay.
  Future<List<Blog>> getBlogPosts() async {
    return await service.fetchAllBlogs();
  }

  // Gibt nur den gewünschten Blog zurück
  Future<Blog> getBlogPost(String blogId) async {
    return await service.fetchBlog(blogId);
  }

  /// Creates a new blog post and sets a new id.
  Future<void> addBlogPost(Blog blog) async {
    await service.postBlog(blog);

    notifyListeners();
  }

  /// Deletes a blog post.
  Future<void> deleteBlogPost(Blog blog) async {
    // _blogs.remove(blog);

    notifyListeners();
  }

  /// Changes the like info of a blog post.
  Future<void> toggleLikeInfo(String blogId) async {
    // final blog = _blogs.firstWhere((blog) => blog.id == blogId);
    // blog.isLikedByMe = !blog.isLikedByMe;

    notifyListeners();
  }

  /// Updates a blog post with the given id.
  Future<void> updateBlogPost(
      {required String blogId,
      required String? title,
      required String? content}) async {

    // final blog = _blogs.firstWhere((blog) => blog.id == blogId);

    // if(title != null){ blog.title = title; }
    // if(content != null){ blog.content = content; }

    notifyListeners();
  }
}