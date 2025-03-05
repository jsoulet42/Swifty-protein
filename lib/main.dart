import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './screens/splash_screen.dart';
import './screens/login_screen.dart';
import './screens/protein_search_screen.dart'; // Assurez-vous que le fichier s'appelle bien "protein_search_screen.dart"

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swifty Protein',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      // Définition des routes principales. Les écrans qui nécessitent des arguments (ex. LigandDetailScreen) sont appelés via MaterialPageRoute.
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/proteinSearch': (context) => const ProteinSearchScreen(),
      },
    );
  }
}
