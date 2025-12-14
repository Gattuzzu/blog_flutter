import 'dart:async';
import 'package:blog_beispiel/screens/blog_overview/blog_overview_state.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:blog_beispiel/services/helper/result.dart';
import 'package:flutter/material.dart';

class BlogOverviewModel extends ChangeNotifier {
  BlogOverviewState _state = BlogOverviewInitial();

  BlogOverviewModel() {
    readBlogsWithLoadingState();
  }

  BlogOverviewState get state => _state;

  Future<void> readBlogsWithLoadingState() async {
    _state = BlogOverviewLoading();
    notifyListeners();  // Löst Rebuild aus

    var result = await BlogRepository.instance.getBlogPosts();

    switch(result){
      case Success(data: var blogs): _state = BlogOverviewLoaded(blogs);
      case Failure(error: var e): _state = BlogOverviewError(e.toString());
    }

    notifyListeners();  // Löst Rebuild aus
  }

  Future<void> toggleLike(String blogId) async {
    await BlogRepository.instance.toggleLikeInfo(blogId);
    await readBlogsWithLoadingState();
  }
}