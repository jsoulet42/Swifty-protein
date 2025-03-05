// !!! IMPORTANT : MODIFIER CE FICHIER POUR CHAQUE NOUVEAU PROJET !!!
// Ce fichier configure la gestion des plugins et inclut le projet Flutter.
// ADAPTEZ LES CHEMINS ET VERSIONS SI NÉCESSAIRE.

pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // !!! IMPORTANT : METTRE À JOUR CES VERSIONS POUR CHAQUE NOUVEAU PROJET SI NÉCESSAIRE.
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.3.0" apply false  // Compatible avec Gradle 8.x
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false // !!! IMPORTANT : VERSION DU PLUGIN KOTLIN À ADAPTER.
    id("com.google.gms.google-services") version "4.4.1" apply false  // Plugin Firebase GMS, MODIFIER SI NÉCESSAIRE
}

include(":app")
