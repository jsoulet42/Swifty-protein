import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../utils/logger.dart';
import 'ligand_detail_screen.dart';

class ProteinSearchScreen extends StatefulWidget {
  const ProteinSearchScreen({super.key});

  @override
  State<ProteinSearchScreen> createState() => _ProteinSearchScreenState();
}

class _ProteinSearchScreenState extends State<ProteinSearchScreen> {
  List<String> ligandCodes = [];

  @override
  void initState() {
    super.initState();
    Logger.log(
      "Initialisation de ProteinSearchScreen",
      tag: "ProteinSearchScreen",
    );
    loadLigandCodes();
  }

  // Charge le fichier texte et extrait les codes (un code par ligne)
  Future<void> loadLigandCodes() async {
    try {
      final String data = await rootBundle.loadString('lib/ligands.txt');
      final List<String> codes =
          data
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList();
      Logger.log("Codes chargés: ${codes.length}", tag: "ProteinSearchScreen");
      setState(() {
        ligandCodes = codes;
      });
    } catch (e) {
      Logger.log(
        "Erreur lors du chargement des codes de ligands: $e",
        tag: "ProteinSearchScreen",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche de Ligands")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            ligandCodes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return ligandCodes.where(
                      (String option) => option.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    );
                  },
                  onSelected: (String selection) {
                    Logger.log(
                      "Vous avez sélectionné: $selection",
                      tag: "ProteinSearchScreen",
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Sélectionné: $selection")),
                    );
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                LigandDetailScreen(ligandCode: selection),
                      ),
                    );
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: "Entrez un code de ligand",
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options,
                  ) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          color: Colors.white,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return ListTile(
                                title: Text(option),
                                onTap: () {
                                  onSelected(option);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
