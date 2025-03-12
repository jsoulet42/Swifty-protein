// !!! IMPORTANT : MODIFIER CE FICHIER POUR CHAQUE NOUVEAU PROJET !!!
// Ce fichier configure l'application Android. Veillez à adapter le namespace, l'applicationId et éventuellement les versions.

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Plugin Firebase, MODIFIER SI NÉCESSAIRE
}

android {
    // !!! IMPORTANT : MODIFIER LE NAMESPACE POUR CHAQUE NOUVEAU PROJET !!!
    namespace = "com.example.swiftyprotein"
    compileSdk = 35 // !!! IMPORTANT : VÉRIFIER ET METTRE À JOUR LA COMPILE SDK SI BESOIN.
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // !!! IMPORTANT : MODIFIER L'APPLICATION ID POUR CHAQUE NOUVEAU PROJET !!!
        applicationId = "com.example.swiftyprotein"
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    // !!! IMPORTANT : VÉRIFIER LE CHEMIN SOURCE EN FONCTION DE L'ORGANISATION DE VOTRE PROJET.
    source = "../.."
}

dependencies {
    // !!! IMPORTANT : ADAPTEZ CES DÉPENDANCES SELON VOS BESOINS POUR CHAQUE PROJET.
    implementation(platform("com.google.firebase:firebase-bom:32.7.1")) // Firebase BoM
    implementation("com.google.firebase:firebase-auth:22.3.1")
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}
