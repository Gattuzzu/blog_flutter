import 'package:gattus_blog/di/get_it_setup.dart';
import 'package:gattus_blog/main_view_model.dart';
import 'package:gattus_blog/domain/models/language.dart';
import 'package:gattus_blog/data/router/app_routes.dart';
import 'package:gattus_blog/data/language/language_service.dart';
import 'package:gattus_blog/ui/profile/profile_screen.dart';
import 'package:gattus_blog/ui/profile/profile_view_model.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
          ChangeNotifierProvider<ProfileViewModel>(
            create: (_) => getIt<ProfileViewModel>(),
            child: Profile(onPressed: () => Scaffold.of(context).closeDrawer()),
          ),
          Expanded(
            child: Container()
          ),
          Text("Colors"),
          Row(
            children: List.generate(colorList.length, (index) {
              final color = colorList[index];
              return IconButton(
                onPressed: () {
                    getIt<MainViewModel>().updateColor(color);
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
