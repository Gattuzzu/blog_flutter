import 'dart:async';
import 'dart:io';

import 'package:blog_beispiel/data/logger/logger.util.dart';
import 'package:blog_beispiel/domain/models/blog.dart';
import 'package:blog_beispiel/data/apis/blog_service.dart';
import 'package:blog_beispiel/data/exceptions/app_exception.dart';
import 'package:blog_beispiel/data/helper/result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class BlogRepository extends ChangeNotifier {
  final Logger log = getLogger();

  final BlogService service;

  BlogRepository({required this.service});

  /// Returns all blog posts ordered by publishedAt descending.
  /// Simulates network delay.
  Future<Result<List<Blog>>> getBlogPosts() async {
    return await _standardErrorCatch<List<Blog>>(() async
    {
      List<Blog> blogList = await service.fetchAllBlogs();
      blogList.sort((blogA, blogB) => blogB.publishedAt.compareTo(blogA.publishedAt));
      return blogList;
    });
  }

  // Gibt nur den gewünschten Blog zurück
  Future<Result<Blog>> getBlogPost(String blogId) async {
    return await _standardErrorCatch<Blog>(() async => await service.fetchBlog(blogId));
  }

  /// Creates a new blog post and sets a new id.
  Future<Result<void>> addBlogPost(Blog blog) async {
    return await _standardErrorCatch<void>(() async => await service.postBlog(blog));
  }

  /// Deletes a blog post.
  Future<Result<void>> deleteBlogPost(String blogId) async {
    return await _standardErrorCatch<void>(() async => await service.deleteBlog(blogId));
  }

  /// Changes the like info of a blog post.
  Future<Result<void>> toggleLikeInfo(String blogId) async {
    // final blog = _blogs.firstWhere((blog) => blog.id == blogId);
    // blog.isLikedByMe = !blog.isLikedByMe;

    return Failure(Exception("Toggle Like is not yet implemented!"));
  }

  /// Updates a blog post with the given id.
  Future<Result<void>> updateBlogPost(
      {required String blogId,
      required String? title,
      required String? content}) async {

    return await _standardErrorCatch<void>(() async => await service.patchBlog(blogId, title, content));
  }

  Future<Result<T>> _standardErrorCatch<T>(Future<T> Function() action) async {
    try{
      Result<T> result = Success(await action());
      log.i("Der Blog konnte erfolgreich geladen werden!");
      return result;

    } on SocketException{
      log.e("Beim Laden kam es zu einem Netzwerkfehler!");
      return Failure(NetworkException());

    } catch (e){
      log.e("Der Blog konnte nicht geladen werden!");
      return Failure(ServerException(e.toString()));
    }
  }
}