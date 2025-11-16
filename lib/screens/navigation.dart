import 'package:blog_beispiel/models/language.dart';
import 'package:blog_beispiel/screens/second_screen.dart';
import 'package:blog_beispiel/services/language_service.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  final List<Language> languageList = LanguageService().getLanguages();

  Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Column(
        children: [
          SizedBox(height: 15),
          TextButton(onPressed: () => onPressed(context, "Overview"), child: Text("Overview")),
          TextButton(onPressed: () => onPressed(context, "New Blog Entry"), child: Text("New Blog Entry")
          ),
          TextButton(onPressed: () => onPressed(context, "Login"), child: Text("Login")),
          Expanded(
            child: Container()
          ),
          Text("Language"),
          Row(
            children: List.generate(languageList.length, (index) {
              final language = languageList[index];
              return IconButton(
                onPressed: () => onPressed(context, language.name), 
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

  onPressed(context, String title) => {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => SecondScreen(title: title))
    )
  };
}
