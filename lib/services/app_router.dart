import 'package:blog_beispiel/models/blog.dart';
import 'package:blog_beispiel/screens/add_blog.dart';
import 'package:blog_beispiel/screens/blog_detail_screen.dart';
import 'package:blog_beispiel/screens/blog_overview.dart';
import 'package:blog_beispiel/screens/bottom_navigation.dart';
import 'package:blog_beispiel/screens/second_screen.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home, // Startseite
  routes: [
    // Alle vorhanden Routen hier definieren
    ShellRoute(
      builder: (context, state, child){
        return BottomNavigation(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home, 
          redirect: (context, state) {
            return AppRoutes.blogOverview;
          }
        ),
        GoRoute(
          path: AppRoutes.addBlog, 
          pageBuilder: (context, state) => const NoTransitionPage(child: AddBlog()),
        ),
        GoRoute(
          path: AppRoutes.blogOverview,
          pageBuilder: (context, state) => const NoTransitionPage(child: BlogOverview()),
          routes: [
            GoRoute(
              path: AppRoutes.blogDetail,
              pageBuilder: (context, state){
                final blog = state.extra as Blog;
                return NoTransitionPage(child: BlogDetailScreen(blog: blog));
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.secondScreen,
          pageBuilder: (context, state) => const NoTransitionPage(child: SecondScreen(title: "Second Screen")),
        ),
        GoRoute(
          path: AppRoutes.login,
          redirect: (context, state) {
            return AppRoutes.secondScreen;
          }
        ),
      ],
    )
  ],
);