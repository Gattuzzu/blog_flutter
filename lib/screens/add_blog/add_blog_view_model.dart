import 'dart:async';
import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:flutter/material.dart';

class AddBlogViewModel extends ChangeNotifier {
  bool isLoading = false;

  AddBlogViewModel();

  Future<void> addBlog(Blog blog, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 5000));
    await BlogRepository.instance.addBlogPost(blog);

    isLoading = false;
    if(!context.mounted) return; // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
    notifyListeners();
  }
}