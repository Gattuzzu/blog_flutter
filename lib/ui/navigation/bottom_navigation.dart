import 'package:gattus_blog/data/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget {
  final ValueNotifier<bool> isAuthenticated;

  const BottomNavigation({
    super.key,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isAuthenticated,
      builder: (context, authenticated, child) {
        return BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) => _onItemTapped(index, context),
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Overview"),
            BottomNavigationBarItem(
              // Optisches Feedback: Icon ändern oder ausgrauen, wenn nicht eingeloggt
              icon: Icon(Icons.add, color: authenticated ? null : Colors.grey),
              label: "Add",
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.keyboard_return), label: "Back"),
          ],
        );
      },
    );
  }

  static int _calculateSelectedIndex(BuildContext context){
    final String location = GoRouterState.of(context).uri.path;
    return switch(location){
      AppRoutes.blogOverview => 0,
      AppRoutes.addBlog      => 1,
      AppRoutes.back         => 2,
      _ => 0, // Default Case
    };
  }

  String _routeOfIndex(int index){
    return switch(index){
      0 => AppRoutes.blogOverview,
      1 => AppRoutes.addBlog,
      2 => AppRoutes.back,
      _ => "", // Default-Case: Wird der Switch direkt einer Variable initialisiert, wird ein Default-Case benötigt 
    };
  }

  void _onItemTapped(int index, BuildContext context){
    final String currentLocation = GoRouterState.of(context).uri.path;
    final String newLocation = _routeOfIndex(index);

    if (currentLocation != newLocation){
      if(newLocation == AppRoutes.back){
        // Es darf nur ein pop() ausgeführt werden, wenn dies auch möglich ist, da es sonst zu einem Fehler kommt. -> Es kann nicht auf eine Seite Navigieren, welche es nicht gibt.
        if(context.canPop()) {
          context.pop();
        } // else { nichts machen }

      } else if(newLocation == AppRoutes.addBlog){
        if(isAuthenticated.value){
          context.push(newLocation);
        } else {
          // Meldung anzeigen, dass man sich erst einloggen muss.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Please login first!"), backgroundColor: Theme.of(context).colorScheme.primary,),
          );
        }
      }else{
        // alle anderen Routen
        // Mit push(), statt go() kann später auch auf eine Route zurück gekehrt werden, welche nicht im Parenttree ist.
        context.push(newLocation);
      }
    }
  }
}
