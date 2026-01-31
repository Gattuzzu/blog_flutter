import 'package:gattus_blog/ui/blog_overview/blog_card.dart';
import 'package:gattus_blog/ui/blog_overview/blog_overview_model.dart';
import 'package:gattus_blog/ui/blog_overview/blog_overview_state.dart';
import 'package:gattus_blog/data/router/app_routes.dart';
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
    final viewModel = context.watch<BlogOverviewModel>();
    return FocusDetector(
      onFocusGained: () => viewModel.readBlogsWithLoadingState(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo){
          // Das wird benötigt, wenn die Blogliste angezeigt wird, und sie der User neu laden möchte.
          if(scrollInfo is ScrollEndNotification){
            if(viewModel.state is BlogOverviewLoaded && scrollInfo.metrics.pixels < 0){
              viewModel.readBlogsWithLoadingState();
            }
          }

          // Das wird benötigt, wenn die Blogliste nicht angezeigt wird, und z.B. ein Fehler angezeigt wird. 
          // Dann soll der User die Möglichkeit haben durch wischen ein Update auszuführen.
          if(scrollInfo is UserScrollNotification){
            // Der User wischt mit dem Finger nach Unten
            if((viewModel.state is BlogOverviewInitial 
                || viewModel.state is BlogOverviewError)
               && scrollInfo.direction == ScrollDirection.forward
               // -10 verwenden, dass das neuladen erst nach einem guten Scroll gemacht wird, und nicht bei jedem Pixel.
               && scrollInfo.metrics.pixels <= 0){
              viewModel.readBlogsWithLoadingState();
            }
          }

          return false;
        },
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if(viewModel.state is BlogOverviewInitial)
                _buildScrollableContent(const Text("Initial"))

              else if(viewModel.state case BlogOverviewError(message: var msg))
                _buildScrollableContent(Text(msg))

              else if(viewModel.state case BlogOverviewAtLeastOnceLoaded(blogs: var blogs))
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
                          onLikeToggle: () => viewModel.toggleLike(blog.id, !blog.isLikedByMe),
                          onTap: () => _onBlogTap(context, blog.id),
                          isAutenticated: viewModel.isAuthenticated,
                        );
                      },
                    ),
              
              if(viewModel.state case BlogOverviewLoading() || BlogOverviewUpdating())
                const Center(child: CircularProgressIndicator()),
              
              if(viewModel.isAuthenticated)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () => _onAddBlog(context),
                    child: const Icon(Icons.add),
                  )
                ),
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
