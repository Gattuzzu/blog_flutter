import 'package:blog_beispiel/models/blog.dart';

enum BlogField {
  title("Title"), 
  content("Content");

  final String label;

  const BlogField(this.label);
}

String errorDuringDevelopment = "Error during development: Page in the wrong state!";

sealed class BlogDetailState {}

class BlogDetailInitial extends BlogDetailState {}

class BlogDetailLoading extends BlogDetailState {}

class BlogDetailError extends BlogDetailState {
  final String message;
  BlogDetailError(this.message);
}


sealed class BlogAtLeastOnceLoaded extends BlogDetailState {
  final Blog blog;
  BlogAtLeastOnceLoaded(this.blog);
}

class BlogDetailLoaded extends BlogAtLeastOnceLoaded {
  BlogDetailLoaded(super.blog);
}

class BlogDetailEditing extends BlogAtLeastOnceLoaded {
  final BlogField field;
  BlogDetailEditing(this.field, super.blog);
}

class BlogDetailUpdating extends BlogAtLeastOnceLoaded {
  BlogDetailUpdating(super.blog);
}

class BlogDetailDeleting extends BlogAtLeastOnceLoaded {
  BlogDetailDeleting(super.blog);
}