import 'package:flutter/material.dart';
import '../services/rcsb_api_service.dart';
import '../utils/logger.dart';

class LigandDetailScreen extends StatefulWidget {
  final String ligandCode;
  const LigandDetailScreen({super.key, required this.ligandCode});

  @override
  State<LigandDetailScreen> createState() => _LigandDetailScreenState();
}

class _LigandDetailScreenState extends State<LigandDetailScreen> {
  late Future<LigandDetail> futureLigandDetail;

  @override
  void initState() {
    super.initState();
    Logger.log(
      "Initialisation de LigandDetailScreen pour le ligand: ${widget.ligandCode}",
      tag: "LigandDetailScreen",
    );
    futureLigandDetail = RcsbApiService.fetchLigandDetailFromChemcomp(
      widget.ligandCode,
    );
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
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
