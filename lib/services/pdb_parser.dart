import '../models/atom.dart';
import '../models/bond.dart';
import '../utils/logger.dart';

class SdfParser {
  /// Parse la section atomes du fichier SDF
  static List<Atom> parseAtoms(String sdfContent) {
    List<String> lines = sdfContent.split('\n');
    if (lines.length < 4) {
      Logger.log(
        "Fichier SDF trop court pour contenir la ligne de compte.",
        tag: "SDF_PARSER",
      );
      return [];
    }

    // La quatrième ligne (index 3) est la ligne de compte
    String countsLine = lines[3];
    // Les 3 premiers caractères indiquent le nombre d'atomes
    int numAtoms = int.tryParse(countsLine.substring(0, 3).trim()) ?? 0;

    Logger.log(
      "Nombre d'atomes indiqué dans le fichier : $numAtoms",
      tag: "SDF_PARSER",
    );

    List<Atom> atoms = [];
    // Les atomes se trouvent à partir de la ligne 5 (index 4)
    for (int i = 4; i < 4 + numAtoms && i < lines.length; i++) {
      String line = lines[i];
      try {
        double x = double.parse(line.substring(0, 10).trim());
        double y = double.parse(line.substring(10, 20).trim());
        double z = double.parse(line.substring(20, 30).trim());
        // La colonne 32-34 contient le symbole de l'atome (en 1-indexé, c'est en fait positions 31 à 33 en 0-indexé)
        String symbol = line.substring(31, 34).trim();
        // L'index des atomes sera leur ordre d'apparition (0-indexé)
        atoms.add(Atom(i - 4, symbol, x, y, z));
      } catch (e) {
        Logger.log(
          "Erreur de parsing d'une ligne d'atome (ligne ${i + 1}) : $line",
          tag: "SDF_PARSER",
        );
      }
    }
    return atoms;
  }

  /// Parse la section liaisons du fichier SDF
  static List<Bond> parseBonds(String sdfContent) {
    List<String> lines = sdfContent.split('\n');
    if (lines.length < 4) {
      Logger.log(
        "Fichier SDF trop court pour contenir la ligne de compte.",
        tag: "SDF_PARSER",
      );
      return [];
    }

    String countsLine = lines[3];
    int numAtoms = int.tryParse(countsLine.substring(0, 3).trim()) ?? 0;
    int numBonds = int.tryParse(countsLine.substring(3, 6).trim()) ?? 0;

    Logger.log(
      "Nombre de liaisons indiqué dans le fichier : $numBonds",
      tag: "SDF_PARSER",
    );

    List<Bond> bonds = [];
    // Les liaisons se trouvent après la section des atomes
    int bondStartIndex = 4 + numAtoms;
    for (
      int i = bondStartIndex;
      i < bondStartIndex + numBonds && i < lines.length;
      i++
    ) {
      String line = lines[i];
      try {
        // Dans le format Molfile, les 3 premiers caractères donnent l'indice du premier atome
        // et les 3 suivants l'indice du second atome (les indices sont 1-indexés)
        int a1 = int.tryParse(line.substring(0, 3).trim()) ?? 0;
        int a2 = int.tryParse(line.substring(3, 6).trim()) ?? 0;
        // Conversion en index 0-based
        bonds.add(Bond(a1 - 1, a2 - 1));
        Logger.log(
          "Liaison ajoutée : Atome $a1 lié à Atome $a2",
          tag: "SDF_PARSER",
        );
      } catch (e) {
        Logger.log(
          "Erreur de parsing d'une ligne de liaison (ligne ${i + 1}) : $line",
          tag: "SDF_PARSER",
        );
      }
    }
    Logger.log(
      "Nombre de liaisons extraites : ${bonds.length}",
      tag: "SDF_PARSER",
    );
    return bonds;
  }
}
