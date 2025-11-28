import 'dart:async';
import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AddBlogPageState {loading, editing, done}

class AddBlogViewModel extends ChangeNotifier {
  AddBlogPageState _pageState = AddBlogPageState.editing;
  final formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";

  AddBlogPageState get pageState => _pageState;

  AddBlogViewModel();

  // Form Validatoren 
  String? titleValidator(String? value) => Blog.titleValidator(value);
  String? contentValidator(String? value) => Blog.contentValidator(value);

  Future<void> onSave(BuildContext context) async {
    if(_pageState == AddBlogPageState.loading){
      return;

    } else{
      if (formKey.currentState != null)
      {
        _pageState = AddBlogPageState.loading;
        final isValid = formKey.currentState!.validate();
        if (isValid){
          // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
          if(context.mounted){
            FocusScope.of(context).unfocus();
          }
          formKey.currentState!.save(); // Die Werte werden in das ViewModel geschrieben
          await addBlog(Blog(
            title: _title,
            content: _content,
            publishedAt: DateTime.now(),
          ), context);

          // Kurz warten bevor weitergeleitet wird zur Overview. 
          // Dann wird noch ein Text angezeigt, dass der Blog erstellt wurde.
          await Future.delayed(const Duration(milliseconds: 3000));

          // Bevor man eine weiterleitung machen kann, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
          if(context.mounted){
            context.push(AppRoutes.blogOverview);
          } 
        } else{ // !isValid
          _pageState = AddBlogPageState.editing;
          if(!context.mounted) return; // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
          notifyListeners();
        }
      }
    }  
  }

  void setTitle(String? value){
    if(value != null){
      _title = value;
    }
  }

  void setContent(String? value){
    if(value != null){
      _content = value;
    }
  }

  Future<void> addBlog(Blog blog, BuildContext context) async {
    _pageState = AddBlogPageState.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 5000));
    await BlogRepository.instance.addBlogPost(blog);

    _pageState = AddBlogPageState.done;
    if(!context.mounted) return; // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
    notifyListeners();
  }
}