import 'dart:async';
import 'dart:io';

import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/blog_service.dart';
import 'package:blog_beispiel/services/exceptions/app_exception.dart';
import 'package:blog_beispiel/services/helper/result.dart';
import 'package:flutter/material.dart';


class BlogRepository extends ChangeNotifier {
  // Static instance + private Constructor for simple Singleton-approach
  static BlogRepository instance = BlogRepository._privateConstructor();
  BlogRepository._privateConstructor();

  var service = BlogService.instance;

  /// Returns all blog posts ordered by publishedAt descending.
  /// Simulates network delay.
  Future<Result<List<Blog>>> getBlogPosts() async {
    try{
      List<Blog> blogList = await service.fetchAllBlogs();
      blogList.sort((blogA, blogB) => blogB.publishedAt.compareTo(blogA.publishedAt));
      return Success(blogList);

    } on SocketException{
      return Failure(NetworkException());
    } catch (e){
      return Failure(ServerException(e.toString()));
    }
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
  Future<void> deleteBlogPost(String blogId) async {
    await service.deleteBlog(blogId);

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

    await service.patchBlog(blogId, title, content);

    notifyListeners();
  }
}