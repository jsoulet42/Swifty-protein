import 'package:flutter/material.dart';
import 'package:swiftyprotein/screens/molecule_3d_view.dart';
import '../services/rcsb_api_service.dart';
import '../utils/logger.dart';
import '../models/ligand_detail.dart'; // Import de LigandDetail

class LigandDetailScreen extends StatefulWidget {
  final String ligandCode;
  const LigandDetailScreen({super.key, required this.ligandCode});

  @override
  State<LigandDetailScreen> createState() => _LigandDetailScreenState();
}

class _LigandDetailScreenState extends State<LigandDetailScreen>
    with WidgetsBindingObserver {
  late Future<LigandDetail> futureLigandDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 👀 Observation du cycle de vie
    _fetchLigandDetails(); // Chargement initial
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      this,
    ); // 🔄 Suppression de l'observateur
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Logger.log(
        "Application revenue au premier plan - rafraîchissement des détails",
        tag: "APP_LIFECYCLE",
      );
      _fetchLigandDetails();
    }
  }

  void _fetchLigandDetails() {
    setState(() {
      futureLigandDetail = RcsbApiService.fetchLigandDetailFromChemcomp(
        widget.ligandCode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails du Ligand")),
      body: FutureBuilder<LigandDetail>(
        future: futureLigandDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Logger.log(
              "Chargement des détails du ligand...",
              tag: "LigandDetailScreen",
            );
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            Logger.log(
              "Erreur lors du chargement des détails: ${snapshot.error}",
              tag: "LigandDetailScreen",
            );
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            Logger.log(
              "Aucun détail trouvé pour le ligand: ${widget.ligandCode}",
              tag: "LigandDetailScreen",
            );
            return const Center(child: Text("Aucun détail trouvé"));
          } else {
            final ligand = snapshot.data!;
            Logger.log(
              "Détails du ligand récupérés: ${ligand.chemCompId} - ${ligand.name}",
              tag: "LigandDetailScreen",
            );
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Code: ${ligand.chemCompId}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Nom: ${ligand.name}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Formule/Description: ${ligand.formula}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Passer le ligandCode à l'écran 3D
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Molecule3DViewScreen(
                                ligandCode: widget.ligandCode,
                              ),
                        ),
                      );
                    },
                    child: const Text("Voir en 3D"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
