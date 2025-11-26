import 'dart:async';
import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:flutter/material.dart';

class BlogDetailViewModel extends ChangeNotifier {
  bool isLoading = false;
  Blog? _blog;

  Blog? get blog => _blog;

  BlogDetailViewModel({required int blogId}) {
    readBlogWithLoadingState(blogId);
  }

  Future<void> readBlogWithLoadingState(int blogId) async {
    isLoading = true;
    notifyListeners();  // Löst Rebuild aus

    await readBlog(withNotifying: false, blogId: blogId);

    isLoading = false;
    notifyListeners();  // Löst Rebuild aus
  }

  Future<void> readBlog({bool withNotifying = true, required int blogId}) async {
    _blog = await BlogRepository.instance.getBlogPost(blogId);
    if (withNotifying) {
      notifyListeners();  // Löst Rebuild aus
    }
  }

  Future<void> toggleLike(int blogId) async {
    await BlogRepository.instance.toggleLikeInfo(blogId);
    await readBlogWithLoadingState(blogId);
  }
}