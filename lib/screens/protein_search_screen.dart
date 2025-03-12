import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shimmer/shimmer.dart';
import '../utils/logger.dart';
import 'ligand_detail_screen.dart';

class ProteinSearchScreen extends StatefulWidget {
  const ProteinSearchScreen({super.key});

  @override
  State<ProteinSearchScreen> createState() => _ProteinSearchScreenState();
}

class _ProteinSearchScreenState extends State<ProteinSearchScreen>
    with WidgetsBindingObserver {
  List<String> ligandCodes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadLigandCodes();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Logger.log(
        "Application revenue au premier plan - rechargement de la liste",
        tag: "APP_LIFECYCLE",
      );
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          loadLigandCodes();
        }
      });
    }
  }

  Future<void> loadLigandCodes() async {
    try {
      final String data = await rootBundle.loadString('lib/ligands.txt');
      final List<String> codes =
          data
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList();

      if (!mounted) return;
      setState(() {
        ligandCodes = codes;
        isLoading = false;
      });
    } catch (e) {
      Logger.log(
        "Erreur lors du chargement des codes de ligands: $e",
        tag: "ProteinSearchScreen",
      );
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche de Ligands")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: [
                        // IMAGE DE FOND (VISIBLE)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/imagebackG.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // EFFET SHIMMER (SANS withOpacity)
                        Positioned.fill(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withAlpha(
                                      10,
                                    ), // Lumière shimmer
                                    Colors.grey[300]!,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : ligandCodes.isEmpty
                ? const Center(
                  child: Text(
                    "Aucun ligand disponible",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
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
                      "Sélectionné: $selection",
                      tag: "ProteinSearchScreen",
                    );
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
                ),
      ),
    );
  }
}
