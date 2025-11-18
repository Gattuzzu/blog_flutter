import 'package:blog_beispiel/services/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigation extends StatelessWidget{
  final Widget child;

  const BottomNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndey(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Overview"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.keyboard_return), label: "Back")
        ]
      ),
    );
  }

  static int _calculateSelectedIndey(BuildContext context){
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
    final String newLoaction = _routeOfIndex(index);
    if (currentLocation != newLoaction){
      if(newLoaction == AppRoutes.back){
        // Es darf nur ein pop() ausgeführt werden, wenn dies auch möglich ist, da es sonst zu einem Fehler kommt. -> Es kann nicht auf eine Seite Navigieren, welche es nicht gibt.
        if(context.canPop()) {
          context.pop();
        } // else { nichts machen }

      } else{
        // alle anderen Routen
        // Mit push(), statt go() kann später auch auf eine Route zurück gekehrt werden, welche nicht im Parenttree ist.
        context.push(newLoaction);
      }
    }
  }
  
}

