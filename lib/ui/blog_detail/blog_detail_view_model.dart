import 'dart:async';
import 'package:blog_beispiel/domain/models/blog.dart';
import 'package:blog_beispiel/ui/blog_detail/blog_detail_state.dart';
import 'package:blog_beispiel/data/router/app_routes.dart';
import 'package:blog_beispiel/data/repositorys/blog_repository.dart';
import 'package:blog_beispiel/data/exceptions/app_exception.dart';
import 'package:blog_beispiel/data/helper/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogDetailViewModel extends ChangeNotifier {
  BlogDetailState _state = BlogDetailInitial();
  final formKey = GlobalKey<FormState>();

  BlogField? _field;
  String? _title;
  String? _content;

  BlogDetailState get state => _state;
  BlogField? get field => _field;

  void setTitle(String? value) => _title = value;
  void setContent(String? value) => _content = value;

  void setPageStateToEdit(BlogField field){
    if(_state case BlogDetailAtLeastOnceLoaded actState){
      _state = BlogDetailEditing(field, actState.blog);
      _field = field;

    } else{
      _state = BlogDetailError(errorDuringDevelopment);
    }

    notifyListeners();
  } 

  void setPageStateToDone() {
    if(_state case BlogDetailAtLeastOnceLoaded actState){
      _state = BlogDetailLoaded(actState.blog);

    } else{
      _state = BlogDetailError(errorDuringDevelopment);
    }

    notifyListeners();
  } 

  // Form Validatoren 
  String? titleValidator(String? value) => Blog.titleValidator(value);
  String? contentValidator(String? value) => Blog.contentValidator(value);

  BlogDetailViewModel({required String blogId}) {
    readBlogWithLoadingState(blogId);
  }

  Future<void> readBlogWithLoadingState(String blogId) async {
    _state = BlogDetailLoading();
    notifyListeners();  // Löst Rebuild aus

    await _readBlog(blogId); // Löst Rebuild aus
  }

  Future<void> _readBlog(String blogId) async {
    var result = await BlogRepository.instance.getBlogPost(blogId);

    _state = switch(result){
      Success() => BlogDetailLoaded(result.data),
      Failure() => BlogDetailError(result.error.toString()),
    };

    notifyListeners();  // Löst Rebuild aus
  }

  Future<void> toggleLike(String blogId) async {
    await BlogRepository.instance.toggleLikeInfo(blogId);
    await readBlogWithLoadingState(blogId);
  }

    Future<void> onUpdate(String blogId, BuildContext context) async {
    if(_state is BlogDetailLoading ||
       _state is BlogDetailUpdating){
      return;

    } else{
      if (_state case BlogDetailEditing actState){
        if (formKey.currentState != null)
        {
          _state = BlogDetailUpdating(actState.blog);
          notifyListeners();
          final isValid = formKey.currentState!.validate();
          if (isValid){
            // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
            if(context.mounted){
              FocusScope.of(context).unfocus();
            }
            formKey.currentState!.save(); // Die Werte werden in das ViewModel geschrieben
            await updateBlog(blogId, _title, _content, context);

          } else{ // !isValid
            _state = BlogDetailEditing(actState.field, actState.blog);
            if(!context.mounted) return; // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
            notifyListeners();
          }
        }

      } else{
        _state = BlogDetailError(errorDuringDevelopment);
        notifyListeners();
      }
    }  
  }

  Future<void> updateBlog(String blogId, String? title, String? content, BuildContext context) async {
    if(_state case BlogDetailAtLeastOnceLoaded actState){
      _state = BlogDetailUpdating(actState.blog);
      notifyListeners();

      await BlogRepository.instance.updateBlogPost(blogId: blogId, title: title, content: content);
      if(!context.mounted) return; // Bevor der BuildContext in der nächsten Methode übergeben werden kann, muss geprüft werden, dass er noch im sichtbaren tree von Flutter ist.
      await _readBlog(blogId); // Löst Rebuild aus
      
    } else{
      _state = BlogDetailError(errorDuringDevelopment);
      notifyListeners();
    }
  }

  Future<void> deleteBlog(String blogId, BuildContext context) async{
    if(_state case BlogDetailAtLeastOnceLoaded actState){
      _state = BlogDetailDeleting(actState.blog);
      notifyListeners();
      
      await BlogRepository.instance.deleteBlogPost(blogId);

      _state = BlogDetailInitial();
      if(!context.mounted) return; // Bevor man eine Methode auf dem context ausgeführen kann, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
      if(context.canPop()) { // Die Route darf nur .pop() gemacht werden, wenn dies möglich ist.
        context.pop();
      } // else { nichts machen }
      // Anschlissend soll in jedemFall zum BlogOverview navigiert werden.
      context.push(AppRoutes.blogOverview);

    } else{
      _state = BlogDetailError(errorDuringDevelopment);
      notifyListeners();
    }
  }
}