import 'package:blog_beispiel/models/blog.dart';

sealed class BlogOverviewState {}

class BlogOverviewInitial extends BlogOverviewState {}

class BlogOverviewLoading extends BlogOverviewState {}

class BlogOverviewError extends BlogOverviewState {
  final String message;
  BlogOverviewError(this.message);
}


sealed class BlogOverviewAtLeastOnceLoaded extends BlogOverviewState{
  final List<Blog> blogs;
  BlogOverviewAtLeastOnceLoaded(this.blogs);
}

class BlogOverviewLoaded extends BlogOverviewAtLeastOnceLoaded {
  BlogOverviewLoaded(super.blogs);
}

class BlogOverviewUpdating extends BlogOverviewAtLeastOnceLoaded{
  BlogOverviewUpdating(super.blogs);
}