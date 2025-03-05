# TemplateFlutterFirebaseGoogleAuth
template flutter avec kotlin firebase et googleAuth
# Template Flutter avec Gestion Centralisée des Logs

Ce repository est une base de projet Flutter configurée pour intégrer Firebase Auth, Google Sign-In et d'autres fonctionnalités essentielles. Il inclut une gestion centralisée des logs, vous permettant de garder un code propre, maintenable et évolutif pour tous vos futurs projets.

---

## Table des matières

- [Fonctionnalités](#fonctionnalités)
- [Configuration Android](#configuration-android)
- [Gestion Centralisée des Logs](#gestion-centralisée-des-logs)
- [Installation et Lancement](#installation-et-lancement)
- [Fichier google-services.json et Données Sensibles](#fichier-google-servicesjson-et-données-sensibles)
- [Bonnes Pratiques](#bonnes-pratiques)
- [Version minimale de Flutter requise](#version-minimale-de-flutter-requise)

---

## Fonctionnalités

- **Intégration Firebase** : Initialisation de Firebase pour l'authentification et d'autres services.
- **Connexion avec Google Sign-In** : Authentification utilisateur via Google.
- **Gestion centralisée des logs** : Tous les messages de log passent par une fonction centralisée pour une meilleure maintenance et une adaptation future aisée (possibilité d'ajouter des niveaux de log, stockage dans un fichier, etc.).
- **Configuration optimisée pour Android** : Fichiers Gradle configurés et commentés pour faciliter la personnalisation (namespace, applicationId, versions, etc.).

---

## Configuration Android

Les fichiers de configuration Android (situés dans le dossier `android/`) sont commentés en **ultra visible** pour faciliter leur modification lors de la création d'un nouveau projet.

- **android/app/build.gradle.kts** :  
  - **namespace** et **applicationId** : À modifier pour chaque projet.
  - **Versions SDK** et dépendances Firebase : Adaptables selon vos besoins.

- **android/build.gradle.kts** :  
  - Stratégie de résolution de dépendances pour forcer l'utilisation d'une version précise de Kotlin (ici `2.1.0`).

- **android/settings.gradle.kts** :  
  - Versions des plugins (Android, Kotlin, Google Services) : À adapter selon la configuration de votre projet.

- **android/gradle/wrapper/gradle-wrapper.properties** :  
  - Configuration du Gradle Wrapper, à modifier si nécessaire.

---

## Gestion Centralisée des Logs

La gestion des logs est centralisée dans le fichier `lib/utils/logger.dart`.  
Elle offre une fonction statique `Logger.log` qui :

- Utilise à la fois `dev.log` (pour une intégration fine avec le système de logs Flutter) et `print` pour s'assurer que les logs apparaissent dans le terminal.
- Permet d'ajouter un **tag** pour identifier l'origine du log.
- Vous permet de modifier l'implémentation ultérieurement (par exemple, ajouter l'enregistrement dans un fichier ou gérer des niveaux de log) sans avoir à modifier l'ensemble de votre code.

Exemple d'utilisation dans votre code :

```dart
import 'logger.dart';

void someFunction() {
  Logger.log("Message de test", tag: "TEST");
}
```


## Installation et Lancement

Pour créer un nouveau projet à partir de ce template, procédez comme suit :

Clonez le repository :
```bash
git clone
```
Modifiez les fichiers de configuration :

Dans android/app/build.gradle.kts et android/settings.gradle.kts, mettez à jour le namespace et applicationId pour refléter le nouveau projet.
Important : Le fichier android/app/google-services.json n'est pas inclus dans le repository pour des raisons de sécurité. Téléchargez un nouveau fichier depuis la console Firebase pour votre nouveau projet et placez-le dans le dossier android/app/.
Dans pubspec.yaml, changez le nom et la description du projet.
Personnalisez votre code :

Dans lib/main.dart, modifiez le contenu selon vos besoins.
Utilisez le module lib/utils/logger.dart pour toutes vos opérations de log.
Installation et Lancement
Installation des dépendances et Lancement de l'application  :
```bash
flutter clean
flutter pub get
flutter run
```
Fichier google-services.json et Données Sensibles
Le fichier google-services.json contient les informations de configuration de votre projet Firebase (comme l'ID du projet, le numéro de projet, les clés API, etc.). Pour des raisons de sécurité, ce fichier n'est pas inclus dans le repository.

Que faire ?

Téléchargez le fichier google-services.json depuis la console Firebase pour votre nouveau projet.
Placez-le dans le dossier android/app/ de votre projet.
Bonnes Pratiques
Centralisation des logs :
Utilisez systématiquement Logger.log pour tous les messages de log afin de pouvoir facilement ajuster la stratégie de logging en un seul endroit.

Commentaires Ultra Visibles :
Les fichiers de configuration contiennent des commentaires en majuscules pour signaler clairement les parties à modifier lors de la création d'un nouveau projet.

Mise à jour des dépendances :
Vérifiez régulièrement les versions des plugins et des dépendances pour éviter les incompatibilités et bénéficier des dernières fonctionnalités.

Ce template est conçu pour faciliter le démarrage de vos projets Flutter tout en assurant une configuration robuste et une gestion efficace des logs. N'hésitez pas à adapter et enrichir ce repository selon vos besoins.

---

## Fichier google-services.json et Données Sensibles

Vous pouvez copier-coller directement ce contenu dans votre repository GitHub.  
Le **.gitignore** empêche désormais l'ajout de `android/app/google-services.json` pour protéger vos informations de configuration Firebase, et le README détaille la procédure à suivre pour télécharger et placer ce fichier dans chaque nouveau projet.

---

## Bonnes Pratiques
Centralisation des logs :
Utilisez systématiquement Logger.log pour tous les messages de log afin de pouvoir facilement ajuster la stratégie de logging en un seul endroit.

Commentaires Ultra Visibles :
Les fichiers de configuration contiennent des commentaires en majuscules pour signaler clairement les parties à modifier lors de la création d'un nouveau projet.

Mise à jour des dépendances :
Vérifiez régulièrement les versions des plugins et des dépendances pour éviter les incompatibilités et bénéficier des dernières fonctionnalités.

---

## Version minimale de Flutter requise

Ce template utilise des fonctionnalités récentes de Flutter et nécessite une version minimale pour fonctionner correctement.

### 📌 Version requise :
- **Flutter 3.19.0** ou supérieur
- **Dart 3.7.0** ou supérieur

### 📋 Vérification de votre version de Flutter :
Avant d'utiliser ce template, assurez-vous que vous avez la bonne version de Flutter installée. Vous pouvez vérifier votre version avec la commande suivante :

```bash
flutter --version
