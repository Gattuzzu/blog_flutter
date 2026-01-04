import 'package:blog_beispiel/main.dart';
import 'package:blog_beispiel/models/language.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:blog_beispiel/services/language_service.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navigation extends StatelessWidget {
  final List<Language> languageList = LanguageService().getLanguages();
  final List<Color> colorList = [Colors.deepPurple, Colors.blue, Colors.red, Colors.yellow, Colors.green];

  Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(height: 15),
          TextButton(onPressed: () => closeDrawerAndPushRoute(context, AppRoutes.blogOverview), child: Text("Overview")),
          TextButton(onPressed: () => closeDrawerAndPushRoute(context, AppRoutes.addBlog), child: Text("New Blog Entry")
          ),
          TextButton(onPressed: () => closeDrawerAndPushRoute(context, AppRoutes.login), child: Text("Login")),
          Expanded(
            child: Container()
          ),
          Text("Colors"),
          Row(
            children: List.generate(colorList.length, (index) {
              final color = colorList[index];
              return IconButton(
                onPressed: () {
                    MyAppState.changeColor(color);
                    Scaffold.of(context).closeDrawer();
                  }, 
                icon: Icon(Icons.square, color: color)
              );
            }),
          ),
          Text("Language"),
          Row(
            children: List.generate(languageList.length, (index) {
              final language = languageList[index];
              return IconButton(
                onPressed: () => closeDrawerAndPushRoute(context, AppRoutes.secondScreen), 
                icon: CountryFlag.fromCountryCode(
                  language.countryCode, 
                  theme: const ImageTheme(
                    shape: RoundedRectangle(6),
                  )
                ),
              );
            }),
          ),
          SizedBox(height: 10)
        ]
      )
    );
  }

  void closeDrawerAndPushRoute(BuildContext context, String route){
    Scaffold.of(context).closeDrawer();
    context.push(route);
  }
}
