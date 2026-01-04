import 'package:blog_beispiel/domain/models/blog.dart';

enum BlogField {
  title("Title"), 
  content("Content");

  final String label;

  const BlogField(this.label);
}

sealed class BlogDetailState {}

class BlogDetailInitial extends BlogDetailState {}

class BlogDetailLoading extends BlogDetailState {}

class BlogDetailError extends BlogDetailState {
  final String message;
  BlogDetailError(this.message);
}


sealed class BlogDetailAtLeastOnceLoaded extends BlogDetailState {
  final Blog blog;
  BlogDetailAtLeastOnceLoaded(this.blog);
}

class BlogDetailLoaded extends BlogDetailAtLeastOnceLoaded {
  BlogDetailLoaded(super.blog);
}

class BlogDetailEditing extends BlogDetailAtLeastOnceLoaded {
  final BlogField field;
  BlogDetailEditing(this.field, super.blog);
}

class BlogDetailUpdating extends BlogDetailAtLeastOnceLoaded {
  BlogDetailUpdating(super.blog);
}

class BlogDetailDeleting extends BlogDetailAtLeastOnceLoaded {
  BlogDetailDeleting(super.blog);
}