import 'package:blog_beispiel/data/logger/logger.util.dart';
import 'package:blog_beispiel/ui/add_blog/add_blog_view_model.dart';
import 'package:blog_beispiel/ui/blog_detail/blog_detail_screen.dart';
import 'package:blog_beispiel/ui/blog_detail/blog_detail_view_model.dart';
import 'package:blog_beispiel/ui/blog_overview/blog_overview_model.dart';
import 'package:blog_beispiel/ui/add_blog/add_blog.dart';
import 'package:blog_beispiel/ui/blog_overview/blog_overview.dart';
import 'package:blog_beispiel/ui/navigation/bottom_navigation.dart';
import 'package:blog_beispiel/ui/navigation/navigation.dart';
import 'package:blog_beispiel/ui/second_screen.dart';
import 'package:blog_beispiel/data/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

final Logger _log = getLogger();

void _logToNewRoute(GoRouterState state){
  _log.i("Zu neuer Route navigiert: ${state.uri.toString()}");
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home, // Startseite
  routes: [
    // Alle vorhanden Routen hier definieren
    ShellRoute(
      builder: (context, state, child){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,

            title: Text("Gattus Blog"),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
          body: child,
          
          drawer: Navigation(),
          bottomNavigationBar: const BottomNavigation(),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.home, 
          redirect: (context, state) {
            _logToNewRoute(state);
            return AppRoutes.blogOverview;
          }
        ),
        GoRoute(
          path: AppRoutes.addBlog, 
          pageBuilder: (context, state) {
              _logToNewRoute(state);
              return NoTransitionPage(child: ChangeNotifierProvider(
              create: (_) => AddBlogViewModel(),
              child: const AddBlog()
              )
            );
          },
        ),
        GoRoute(
          path: AppRoutes.blogOverview,
          pageBuilder: (context, state) {
            _logToNewRoute(state);
            return NoTransitionPage(
              child: ChangeNotifierProvider(
                create: (_) => BlogOverviewModel(),
                child: const BlogOverview()
              ),
            );
          },
          routes: [
            GoRoute(
              path: AppRoutes.blogDetail,
              pageBuilder: (context, state) {
                _logToNewRoute(state);
                final blogId = state.pathParameters['id'] ?? '';
                return NoTransitionPage(
                  child: ChangeNotifierProvider(
                    create: (_) => BlogDetailViewModel(blogId: (blogId).toString()),
                    child: BlogDetailScreen(blogId: blogId)
                  )
                );
              }
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.secondScreen,
          pageBuilder: (context, state) {
            _logToNewRoute(state);
            return const NoTransitionPage(child: SecondScreen(title: "Second Screen"));
          },
        ),
        GoRoute(
          path: AppRoutes.login,
          redirect: (context, state) {
            _logToNewRoute(state);
            return AppRoutes.secondScreen;
          }
        ),
      ],
    )
  ],
);