# blog_beispiel

Dieses Projekt ist im zusammenhang mit dem Kurs "Mobile Computing" erstellt worden.
Das Ziel der App ist die anzeige eines Blog-Api. Dabei sollen die Grundfunktionalitäten von Flutter erlernt werden.

## Aufbau des Projektes

Die Ordner Struktur ist mithilfe des Schichten-Modells aufgebaut. Deshalb gibt es folgende 3 Order:

    - lib/
      |- data/
      |- domain/
      |- ui/

Die einzelnen Screens sind anschliessend im Layer-First Model umgesetzt.
So sieht der ui Ordner wie folgt aus:

    - lib/ui/
      |- add_blog/
      |- blog_detail/
      |- blog_overview/
      |- navigation/
      L second_screen.dart

Im jeweiligen Ordner sind alle Dateien zu finden, welche für den jeweiligen Screen benötigt werden.


### GetIt

Beim entwickeln muss man zwingend immer folgenden Befehl absetzen:

    dart run build_runner build --delete-conflicting-outputs

Dieser Befehl hier ist sehr hilfreich, da er laufend die änderungen aufgreifft und das getIt updatet und nicht nur einmalig wie der build Befehl.

    dart run build_runner watch --delete-conflicting-outputs

Dieser bewirkt, dass man auch bei änderungen von Injections diese nachgeführt werden und funktionieren.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Appwrite über httpie ansprechen

### Variablen setzen:
  $appwriteProject = 'X-Appwrite-Project:6568509f75ac404ff6ae'
  $appwriteKey = 'X-Appwrite-Key:ac0f362d0cf82fe3d138195e142c0a87a88cee4e2c48821192fb307e1a1c74ee694246f90082b4441aa98a2edaddead28ed6d18cf08c4de0df90dcaeeb53d14f14fb9eeb2edec6708c9553434f1d8df8f8acbfbefd35cccb70f2ab0f9a334dfd979b6052f6e8b8610d57465cbe8d71a7f65e8d48aede789eef6b976b1fe9b2e2'

### Alle Blogs abfragen:
  http -v "https://cloud.appwrite.io/v1/databases/blog-db/collections/blogs/documents" $appwriteProject $appwriteKey

### Nur ein Blog abfragen:
  http -v "https://cloud.appwrite.io/v1/databases/blog-db/collections/blogs/documents/69397a018c57b1ee5e29" $appwriteProject $appwriteKey


## Publishen

### Keystore erstellen

    keytool -genkey -v -keystore ./upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

Anschliessend muss man ein Passwort für den KeyStore im Terminal erstellen.<br>
Die erstellte Datei (upload-keystore.jks) muss privat behandelt werden und darf nicht in das Repository Eingecheckt werden!

Nun kann muss man eine Datei namens "key.properties" unter "android" erstellen, mit dem folgenden Inhalt:

    storePassword=dein_passwort
    keyPassword=dein_passwort
    keyAlias=upload
    storeFile=/User/name/upload-keystore.jks

Das store und key Passwort ist das selbe.<br>
Auch diese Datei darf auf keinen Fall eingecheckt werden, da diese Passwörter enthält!

Nun muss noch das build.gradle.kts File angepasst werden.

    import java.util.Properties
    import java.io.FileInputStream

    val keystoreProperties = Properties()
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    android {
      signingConfigs {
        create("release") {
          keyAlias = keystoreProperties["keyAlias"] as String
          keyPassword = keystoreProperties["keyPassword"] as String
          storeFile = keystoreProperties["storeFile"]?.let { file(it) }
          storePassword = keystoreProperties["storePassword"] as String
        }
      }

      buildTypes {
        release {
          signingConfig = signingConfigs.getByName("release")
        }
      }
    }


Vor dem Builden wird ein "flutter clean" empfohlen, damit mögliche falsche cached Files nicht fälschlicherweise in den Releasebuild kommen.<br>
Anschliessend kann der Build ganz normal ausgeführt werden.

### Builden

Als erstes muss die App gebuildet werden.
Dies kann mit dem folgenden Befehl gemacht werden:<br>
-> Android bevorzugt AAB Android App Bundle Dateien.<br>
-> Wichtig ist, dass man das flavor angibt.<br>

    flutter build appbundle --flavor production
