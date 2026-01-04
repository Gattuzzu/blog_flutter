import 'dart:async';
import 'package:blog_beispiel/ui/blog_overview/blog_overview_state.dart';
import 'package:blog_beispiel/data/repositorys/blog_repository.dart';
import 'package:blog_beispiel/data/helper/result.dart';
import 'package:flutter/material.dart';

class BlogOverviewModel extends ChangeNotifier {
  BlogOverviewState _state = BlogOverviewInitial();

  BlogOverviewModel() {
    readBlogsWithLoadingState();
  }

  BlogOverviewState get state => _state;

  Future<void> readBlogsWithLoadingState() async {
    if(_state case BlogOverviewAtLeastOnceLoaded actState){
      _state = BlogOverviewUpdating(actState.blogs);

    } else{
      _state = BlogOverviewLoading();
    }
    
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