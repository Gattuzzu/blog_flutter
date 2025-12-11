import 'package:blog_beispiel/screens/blog_card.dart';
import 'package:blog_beispiel/screens/blog_overview/blog_overview_model.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BlogOverview extends StatelessWidget{
  const BlogOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final blogOverviewModel = context.watch<BlogOverviewModel>();
    return FocusDetector(
      onFocusGained: () => blogOverviewModel.readBlogsWithLoadingState(),
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollEndNotification scrollInfo){
          if(!blogOverviewModel.isLoading && scrollInfo.metrics.pixels < 0){
            blogOverviewModel.readBlogsWithLoadingState();
          }
          return false;
        },
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (blogOverviewModel.blogs.isEmpty && !blogOverviewModel.isLoading)
                const Center(child: Text("No Blogs available"))
              else
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: blogOverviewModel.blogs.length,
                  itemBuilder: (context, index){
                    var blog = blogOverviewModel.blogs[index];
                    return BlogCard(
                      blog: blog, 
                      dateFormatter: DateFormat('dd.MM.yyyy'), 
                      onLikeToggle: () => blogOverviewModel.toggleLike(blog.id),
                      onTap: () => _onBlogTap(context, blog.id),
                    );
                  },
                ),
              if (blogOverviewModel.isLoading)
                const Center(child: CircularProgressIndicator()),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () => _onAddBlog(context),
                  child: const Icon(Icons.add),
                )
              )
            ],
          )
        )
      )
    );
  }

  void _onAddBlog(BuildContext context) => context.push(AppRoutes.addBlog);

  void _onBlogTap(BuildContext context, String blogId) => context.push(AppRoutes.toBlogDetail(blogId), extra: blogId);
}
