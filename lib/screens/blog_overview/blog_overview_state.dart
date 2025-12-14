import 'package:blog_beispiel/models/blog.dart';

sealed class BlogOverviewState {}

class BlogOverviewInitial extends BlogOverviewState {}

class BlogOverviewLoading extends BlogOverviewState {}

class BlogOverviewLoaded extends BlogOverviewState {
  final List<Blog> blogs;
  BlogOverviewLoaded(this.blogs);
}

class BlogOverviewError extends BlogOverviewState {
  final String message;
  BlogOverviewError(this.message);
}