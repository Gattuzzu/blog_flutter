import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "ch.hftm.blog_beispiel"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "ch.hftm.blog_beispiel"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionName = flutter.versionName

        // Prüft, ob eine Build-Nummer von GitHub übergeben wurde, sonst Flutter-Standard
        val envBuildNumber = System.getenv("APP_BUILD_NUMBER")
        versionCode = envBuildNumber?.toInt() ?: flutter.versionCode
    }

    signingConfigs {
        create("release") {
            // Versuche erst Umgebungsvariablen (GitHub), dann die lokale Datei
            keyAlias = System.getenv("ANDROID_KEY_ALIAS") ?: keystoreProperties["keyAlias"] as? String
            keyPassword = System.getenv("ANDROID_KEY_PASSWORD") ?: keystoreProperties["keyPassword"] as? String
            storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD") ?: keystoreProperties["storePassword"] as? String
            
            val keystorePath = if (System.getenv("ANDROID_KEYSTORE_PASSWORD") != null) {
                "upload-keystore.jks" // Der Name, den wir im GitHub Script vergeben haben
            } else {
                keystoreProperties["storeFile"] as? String
            }
            storeFile = keystorePath?.let { file(it) }
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release") // WICHTIG: Hier wird der Key verknüpft
        }
    }

    flavorDimensions += "default"
    productFlavors {
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
        }
        create("production") {
            dimension = "default"
            applicationIdSuffix = ".prod"
        }
    }
}

flutter {
    source = "../.."
}
