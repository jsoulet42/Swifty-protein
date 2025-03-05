import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/logger.dart';
import 'protein_search_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _signInWithGoogle() async {
    try {
      Logger.log("🔵 Début du login Google", tag: "LOGIN");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Logger.log("🟠 L'utilisateur a annulé la connexion.", tag: "LOGIN");
        return;
      }

      Logger.log(
        "🟢 Google Sign-In réussi, récupération des credentials...",
        tag: "LOGIN",
      );
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      Logger.log("🟣 Création des credentials Firebase...", tag: "LOGIN");
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Logger.log("🟡 Envoi des credentials à Firebase...", tag: "LOGIN");
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      Logger.log("✅ Connexion réussie !", tag: "LOGIN");
      setState(() {
        _user = userCredential.user;
      });
    } catch (e) {
      Logger.log("❌ Erreur Google Sign-In : $e", tag: "LOGIN");
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    setState(() {
      _user = null;
    });
    Logger.log("Utilisateur déconnecté", tag: "LOGIN");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
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
                    const SizedBox(height: 16),
                    Text(
                      "Bienvenue, ${_user!.displayName ?? "Utilisateur"}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Continuer vers l'écran de recherche
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProteinSearchScreen(),
                          ),
                        );
                      },
                      child: const Text("Continuer"),
                    ),
                    const SizedBox(height: 8),
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
