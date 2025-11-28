import 'dart:async';
import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/services/blog_repository.dart';
import 'package:flutter/material.dart';

enum BlogField {
  title("Title"), 
  content("Content");

  final String label;

  const BlogField(this.label);
}

enum BlogDetailViewPageState {loading, editing, updating, done}

class BlogDetailViewModel extends ChangeNotifier {
  BlogDetailViewPageState _pageState = BlogDetailViewPageState.loading;
  final formKey = GlobalKey<FormState>();
  Blog? _blog;

  BlogField? _field;
  String? _title;
  String? _content;


  BlogDetailViewPageState get pageState => _pageState;
  Blog? get blog => _blog;
  BlogField? get field => _field;

  void setTitle(String? value) => _title = value;
  void setContent(String? value) => _content = value;

  void setPageStateToEdit(BlogField field){
    _pageState = BlogDetailViewPageState.editing;
    _field = field;
    notifyListeners();
  } 
  void setPageStateToDone() {
    _pageState = BlogDetailViewPageState.done;
    notifyListeners();
  } 

  // Form Validatoren 
  String? titleValidator(String? value) => Blog.titleValidator(value);
  String? contentValidator(String? value) => Blog.contentValidator(value);

  BlogDetailViewModel({required int blogId}) {
    readBlogWithLoadingState(blogId);
  }

  Future<void> readBlogWithLoadingState(int blogId) async {
    _pageState = BlogDetailViewPageState.loading;
    notifyListeners();  // Löst Rebuild aus

    await readBlog(withNotifying: false, blogId: blogId);

    _pageState = BlogDetailViewPageState.done;
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

    Future<void> onUpdate(int blogId, BuildContext context) async {
    if(_pageState == BlogDetailViewPageState.loading ||
       _pageState == BlogDetailViewPageState.updating){
      return;

    } else{
      if (formKey.currentState != null)
      {
        _pageState = BlogDetailViewPageState.updating;
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
          _pageState = BlogDetailViewPageState.editing;
          if(!context.mounted) return; // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
          notifyListeners();
        }
      }
    }  
  }

  Future<void> updateBlog(int blogId, String? title, String? content, BuildContext context) async {
    _pageState = BlogDetailViewPageState.updating;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 5000));
    await BlogRepository.instance.updateBlogPost(blogId: blogId, title: title, content: content);

    _pageState = BlogDetailViewPageState.done;
    if(!context.mounted) return; // Bevor man eine notifyListener ausgeführt wird, muss geprüft werden, ob das Widget noch im sichtbaren tree von Flutter ist.
    notifyListeners();
  }
}