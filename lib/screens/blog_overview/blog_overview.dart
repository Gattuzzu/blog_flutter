import 'package:blog_beispiel/screens/blog_card.dart';
import 'package:blog_beispiel/screens/blog_overview/blog_overview_model.dart';
import 'package:blog_beispiel/screens/blog_overview/blog_overview_state.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo){
          // Das wird benötigt, wenn die Blogliste angezeigt wird, und sie der User neu laden möchte.
          if(scrollInfo is ScrollEndNotification){
            if(blogOverviewModel.state is BlogOverviewLoaded && scrollInfo.metrics.pixels < 0){
              blogOverviewModel.readBlogsWithLoadingState();
            }
          }

          // Das wird benötigt, wenn die Blogliste nicht angezeigt wird, und z.B. ein Fehler angezeigt wird. 
          // Dann soll der User die Möglichkeit haben durch wischen ein Update auszuführen.
          if(scrollInfo is UserScrollNotification){
            // Der User wischt mit dem Finger nach Unten
            if((blogOverviewModel.state is BlogOverviewInitial 
                || blogOverviewModel.state is BlogOverviewError)
               && scrollInfo.direction == ScrollDirection.forward
               // -10 verwenden, dass das neuladen erst nach einem guten Scroll gemacht wird, und nicht bei jedem Pixel.
               && scrollInfo.metrics.pixels <= 0){
              blogOverviewModel.readBlogsWithLoadingState();
            }
          }

          return false;
        },
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: [
              switch(blogOverviewModel.state){
                BlogOverviewInitial() => _buildScrollableContent(const Text("Initial")),
                BlogOverviewError(message: var msg) => _buildScrollableContent(Text(msg)),
                BlogOverviewLoaded(blogs: var blogs) => 
                  blogs.isEmpty
                    ? const Center(child: Text("No Blogs available"))
                    : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: blogs.length,
                      itemBuilder: (context, index){
                        var blog = blogs[index];
                        return BlogCard(
                          blog: blog, 
                          dateFormatter: DateFormat('dd.MM.yyyy'), 
                          onLikeToggle: () => blogOverviewModel.toggleLike(blog.id),
                          onTap: () => _onBlogTap(context, blog.id),
                        );
                      },
                    ),
                BlogOverviewLoading() => const Center(child: CircularProgressIndicator()),
              },
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

  Widget _buildScrollableContent(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // WICHTIG: Damit man auch wischen kann, wenn der Inhalt klein ist!
          physics: const AlwaysScrollableScrollPhysics(), 
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // Erzwingt Mindesthöhe des Screens
            ),
            child: Center(child: child), // Zentriert den Text trotzdem
          ),
        );
      },
    );
  }


}
