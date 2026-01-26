import 'package:gattus_blog/domain/models/language.dart';

List<Language> testLanguage = [
  Language(id: 1, name: "Deutsch", countryCode: "DE"),
  Language(id: 2, name: "English", countryCode: "GB"),
  Language(id: 3, name: "French", countryCode: "FR"),
];

class LanguageService {

  List<Language> getLanguages(){
    return testLanguage;
  }
}