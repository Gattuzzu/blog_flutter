import 'dart:async';
import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:flutter/material.dart';

class BlogOverviewModel extends ChangeNotifier {
  bool isLoading = false;
  List<Blog> _blogs = [];

  List<Blog> get blogs => _blogs;

  BlogOverviewModel() {
    readBlogsWithLoadingState();
  }

  Future<void> readBlogsWithLoadingState() async {
    isLoading = true;
    notifyListeners();  // Löst Rebuild aus

    await readBlogs(withNotifying: false);

    isLoading = false;
    notifyListeners();  // Löst Rebuild aus
  }

  Future<void> readBlogs({bool withNotifying = true}) async {
    _blogs = await BlogRepository.instance.getBlogPosts();
    if (withNotifying) {
      notifyListeners();  // Löst Rebuild aus
    }
  }

  Future<void> toggleLike(int blogId) async {
    await BlogRepository.instance.toggleLikeInfo(blogId);
    await readBlogsWithLoadingState();
  }
}