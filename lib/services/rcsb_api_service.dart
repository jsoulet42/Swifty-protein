import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/logger.dart';

class RcsbApiService {
  /// Récupère les détails d'un ligand via l'endpoint "chemcomp" de la Data API de RCSB.
  /// Le code du ligand est converti en majuscules pour respecter le format attendu.
  static Future<LigandDetail> fetchLigandDetailFromChemcomp(
    String ligandCode,
  ) async {
    final code = ligandCode.toUpperCase();
    Logger.log(
      "Appel de l'API RCSB pour récupérer le chemcomp du ligand: $code",
      tag: "RCSB_API",
    );
    final url = 'https://data.rcsb.org/rest/v1/core/chemcomp/$code';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Logger.log("Réponse reçue pour le ligand: $code", tag: "RCSB_API");
      final jsonData = json.decode(response.body);
      Logger.log("Données du ligand: ${jsonData.toString()}", tag: "RCSB_API");

      // Extraction des informations depuis la clé "chem_comp"
      final chemComp = jsonData["chem_comp"];
      final name =
          chemComp != null && chemComp["name"] != null
              ? chemComp["name"]
              : "Nom inconnu";
      final formula =
          chemComp != null && chemComp["formula"] != null
              ? chemComp["formula"]
              : "Formule inconnue";

      return LigandDetail(
        ligandCode: code,
        chemCompId: code,
        name: name.toString(),
        formula: formula.toString(),
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
}

/// Classe représentant les détails d'un ligand.
class LigandDetail {
  final String ligandCode; // Par exemple "HEM"
  final String chemCompId; // Identique au ligandCode
  final String name; // Nom complet du ligand
  final String formula; // Formule ou description du ligand

  LigandDetail({
    required this.ligandCode,
    required this.chemCompId,
    required this.name,
    required this.formula,
  });
}
