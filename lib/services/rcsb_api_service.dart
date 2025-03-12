import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/logger.dart';
import '../models/ligand_detail.dart';

class RcsbApiService {
  /// Récupère les détails du ligand et son identifiant PDB complet
  static Future<LigandDetail> fetchLigandDetailFromChemcomp(
    String ligandCode,
  ) async {
    final code = ligandCode.toUpperCase();
    Logger.log("Appel API RCSB pour le ligand: $code", tag: "RCSB_API");

    // URL pour obtenir les détails du ligand via l'API RCSB
    final url = 'https://data.rcsb.org/rest/v1/core/chemcomp/$code';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final chemComp = jsonData["chem_comp"];
      final name = chemComp?["name"] ?? "Nom inconnu";
      final formula = chemComp?["formula"] ?? "Formule inconnue";

      return LigandDetail(
        ligandCode: code,
        name: name,
        formula: formula,
        chemCompId: chemComp?["id"] ?? "ID inconnu",
      );
    } else {
      Logger.log(
        "Erreur HTTP ${response.statusCode} pour le chemcomp: $code",
        tag: "RCSB_API",
      );
      throw Exception(
        "Erreur HTTP ${response.statusCode} pour le chemcomp: $code",
      );
    }
  }

  /// Télécharge le fichier PDB du ligand en utilisant son ID PDB
  static Future<String> fetchIdealSdfFile(String ligandCode) async {
    final code = ligandCode.toUpperCase();
    final url = 'https://files.rcsb.org/ligands/download/${code}_ideal.sdf';
    Logger.log("🔍 Téléchargement du fichier SDF idéal: $url", tag: "RCSB_API");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Logger.log(
        "Fichier SDF téléchargé avec succès, taille : ${response.body.length} octets",
        tag: "RCSB_API",
      );
      Logger.log(
        "Contenu du fichier SDF : ${response.body.substring(0, 100)}...",
      ); // Affiche les 100 premiers caractères du fichier
      return response.body; // Retourne le contenu du fichier SDF
    } else {
      Logger.log(
        "Erreur HTTP ${response.statusCode} lors du téléchargement du fichier SDF",
        tag: "RCSB_API",
      );
      throw Exception('Erreur lors du téléchargement du fichier SDF');
    }
  }
}
