import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './utils/logger.dart'; // Assurez-vous que le chemin est correct

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration globale des erreurs Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    Logger.log(
      "🔥 ERREUR GLOBALE : ${details.exception}",
      tag: "FLUTTER_ERROR",
    );
    Logger.log("📝 STACKTRACE : ${details.stack}", tag: "FLUTTER_ERROR");
  };

  // INITIALISATION DE FIREBASE
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? _user; // STOCKE L'UTILISATEUR CONNECTÉ

  @override
  void initState() {
    super.initState();
    // Utilisation du Logger pour tous les messages de log
    Logger.log("🔴 L'application démarre !", tag: "INIT");
    Logger.log("🔴 Ceci devrait toujours s'afficher", tag: "INIT");
  }

  Future<void> _signInWithGoogle() async {
    try {
      Logger.log("🔵 Début du login Google", tag: "SIGNIN");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Logger.log("🟠 L'utilisateur a annulé la connexion.", tag: "SIGNIN");
        return;
      }

      Logger.log(
        "🟢 Google Sign-In réussi, récupération des credentials...",
        tag: "SIGNIN",
      );
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      Logger.log("🟣 Création des credentials Firebase...", tag: "SIGNIN");
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Logger.log("🟡 Envoi des credentials à Firebase...", tag: "SIGNIN");
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Vérification du format de la réponse
      Logger.log(
        "🔍 DEBUG : Résultat brut reçu => ${userCredential.additionalUserInfo}",
        tag: "SIGNIN",
      );
      if (userCredential.additionalUserInfo is List) {
        Logger.log(
          "📌 La réponse contient une liste, conversion nécessaire...",
          tag: "SIGNIN",
        );
        final userInfo =
            (userCredential.additionalUserInfo as List)
                .map((e) => e.toString())
                .toList();
        Logger.log("🔍 DEBUG : Liste convertie => $userInfo", tag: "SIGNIN");
      } else {
        Logger.log(
          "✅ Format attendu : ${userCredential.additionalUserInfo}",
          tag: "SIGNIN",
        );
      }

      Logger.log("✅ Connexion réussie !", tag: "SIGNIN");
      Logger.log("👤 Utilisateur: ${userCredential.user}", tag: "SIGNIN");

      setState(() {
        _user = userCredential.user;
      });
    } catch (e, stacktrace) {
      Logger.log("❌ Erreur Google Sign-In : $e", tag: "SIGNIN");
      Logger.log("🔍 Stacktrace : $stacktrace", tag: "SIGNIN");
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Sign-In")),
      body: Center(
        child:
            _user == null
                ? ElevatedButton(
                  onPressed: _signInWithGoogle,
                  child: const Text("Se connecter avec Google"),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          _user!.photoURL != null
                              ? NetworkImage(_user!.photoURL!)
                              : const AssetImage("assets/default_avatar.png")
                                  as ImageProvider,
                      radius: 40,
                    ),
                    Text("Bienvenue, ${_user!.displayName ?? "Utilisateur"}"),
                    Text(_user?.email ?? "Aucune adresse email"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signOut,
                      child: const Text("Se déconnecter"),
                    ),
                  ],
                ),
      ),
    );
  }
}
