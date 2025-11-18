import 'package:blog_beispiel/models/language.dart';
import 'package:blog_beispiel/services/app_routes.dart';
import 'package:blog_beispiel/services/language_service.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navigation extends StatelessWidget {
  final List<Language> languageList = LanguageService().getLanguages();

  Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        children: [
          SizedBox(height: 15),
          TextButton(onPressed: () => context.push(AppRoutes.blogOverview), child: Text("Overview")),
          TextButton(onPressed: () => context.push(AppRoutes.addBlog), child: Text("New Blog Entry")
          ),
          TextButton(onPressed: () => context.push(AppRoutes.login), child: Text("Login")),
          Expanded(
            child: Container()
          ),
          Text("Language"),
          Row(
            children: List.generate(languageList.length, (index) {
              final language = languageList[index];
              return IconButton(
                onPressed: () => context.push(AppRoutes.secondScreen), 
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
        ]));
  }
}
