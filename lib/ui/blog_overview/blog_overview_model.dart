import 'dart:async';
import 'package:blog_beispiel/data/auth/auth_repository.dart';
import 'package:blog_beispiel/ui/blog_overview/blog_overview_state.dart';
import 'package:blog_beispiel/data/repositorys/blog_repository.dart';
import 'package:blog_beispiel/data/helper/result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class BlogOverviewModel extends ChangeNotifier {
  BlogOverviewState _state = BlogOverviewInitial();
  final BlogRepository blogRepository;
  final AuthRepository authRepository;

  bool _isAuthenticated = false;
  VoidCallback? _authListener;

  BlogOverviewModel({required this.blogRepository, required this.authRepository}) {
    _isAuthenticated = authRepository.isAuthenticated.value;

    _authListener = () {
      _isAuthenticated = authRepository.isAuthenticated.value;
      notifyListeners();
    };
    authRepository.isAuthenticated.addListener(_authListener!);

    readBlogsWithLoadingState();
  }

  @override
  void dispose() {
    if(_authListener != null){
      authRepository.isAuthenticated.removeListener(_authListener!);
    }

    super.dispose();
  }

  BlogOverviewState get state => _state;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> readBlogsWithLoadingState() async {
    if(_state case BlogOverviewAtLeastOnceLoaded actState){
      _state = BlogOverviewUpdating(actState.blogs);

    } else{
      _state = BlogOverviewLoading();
    }
    
    notifyListeners();  // Löst Rebuild aus

    var result = await blogRepository.getBlogPosts();

    switch(result){
      case Success(data: var blogs): _state = BlogOverviewLoaded(blogs);
      case Failure(error: var e): _state = BlogOverviewError(e.toString());
    }

    notifyListeners();  // Löst Rebuild aus
  }

  Future<void> toggleLike(String blogId) async {
    await blogRepository.toggleLikeInfo(blogId);
    await readBlogsWithLoadingState();
  }
}